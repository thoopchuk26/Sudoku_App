import 'package:flutter/material.dart';
import 'package:sudoku_app/Square.dart';
import 'package:sudoku_app/solver/solver.dart';
import 'difficulty.dart';
import 'sudoku.dart';

// https://stackoverflow.com/questions/53767950/how-to-periodically-set-state

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Sudoku Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  _MyHomePageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Play Game'),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => PlaySudokuPage()));
              },
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PlaySudokuPage extends StatefulWidget {
  @override
  _PlaySudokuPageState createState() => _PlaySudokuPageState();
}

class _PlaySudokuPageState extends State<PlaySudokuPage> {

  String boardDisplay = '';
  Difficulty diff;
  int choice = 0;
  Sudoku sudoku = new Sudoku(Difficulty.HARD);

  void initState(){
    sudoku.fillValues();
  }

  void difficultySelection(){
    if(choice == 2){
      diff = Difficulty.HARD;
    } else if(choice == 1){
      diff = Difficulty.MEDIUM;
    } else{
      diff = Difficulty.EASY;
    }
  }

  void displayBoard(){
    difficultySelection();
    sudoku = Sudoku(diff);
    sudoku.fillValues();
    boardDisplay = sudoku.giveSudokuBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text('Select Difficulty'),
      ),
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          children: [
            DropdownButton(
                value: choice,
                items: [DropdownMenuItem(
                    child: Text('Easy'),
                    value: 0
                ),
                  DropdownMenuItem(
                      child: Text('Medium'),
                      value: 1
                  ),
                  DropdownMenuItem(
                      child: Text('Hard'),
                      value: 2
                  )],
                onChanged: (value) {
                  setState(() {
                    choice = value;
                  });}
            ),
            RaisedButton(
              child: Text('Generate New Sudoku Grid'),
              onPressed: () {
                displayBoard();
                setState(() {
                });
              },
              ),
            RaisedButton(
              child: Text('Solve Sudoku Board'),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SudokuGridPage(sudoku: sudoku,)));
              },
            ),
            Text('$boardDisplay'),
          ],
        )
      ),
    );
  }
}

class SudokuGridPage extends StatefulWidget {
  SudokuGridPage({Key key, this.sudoku}) : super(key: key);

  final Sudoku sudoku;

  @override
  _SudokuGridPageState createState() => _SudokuGridPageState();
}

class _SudokuGridPageState extends State<SudokuGridPage> {

  List<List<Square>> squares = new List<List<Square>>();
  Solver solver;
  int number = 0;
  bool solved = false;
  bool done = false;

  void squareSelect(Square square){
      square.changeNumber(number + 1);
  }

  List<DropdownMenuItem> itemMaker(){
    List<DropdownMenuItem> numbers = new List<DropdownMenuItem>();
    for(int i = 0; i < 9; i++){
      numbers.add(DropdownMenuItem(
          child: Text((i+1).toString()),
          value: i
      ),);
    }
    return numbers;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> body = new List<Widget>();
    if(!done){
      List<List<Widget>> rows = getRows(widget.sudoku.board);
      for(int i = 0; i < 9; i ++){
        body.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: rows[i],));
      }
    } else{
      List<List<Widget>> rows = getRows(Solver().solveSudoku(widget.sudoku.board));
      for(int i = 0; i < 9; i ++){
        body.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: rows[i],));
      }
    }

    body.add(RaisedButton(
      child: Text('Update'),
      onPressed: () {
        setState((){});
      },
    ));
    body.add(RaisedButton(
      child: Text('Print Solution'),
      onPressed: (){
        print('v Solution v');
        for(int i = 0; i < 9; i++) {
          print(Solver().solveSudoku(widget.sudoku.board)[i]);
        }
        print('^ Solution ^');
      },
    ));
    body.add(DropdownButton(
      items: itemMaker(),
      value: number,
      onChanged: (value) {
        setState(() {
          number = value;
        });}
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text('Play Sudoku', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: body,
        ),
      ),
    );
  }

  // The implementation of GestureDetector for grid visualization is drawn, in
  // large part, from the Boggle game from Project 2.
  List<List<Widget>> getRows(List<List<int>> boards) {
    List<List<Widget>> rows = new List<List<Widget>>();
    for (int i=0; i < 9; i++) {
      squares.add(new List<Square>());
      rows.add(new List<Widget>());
      for (int j=0; j < 9; j++) {
        squares[i].add(new  Square(boards[i][j]));
        rows[i].add(
            GestureDetector(
              child: Container(
                  width: (MediaQuery.of(context).size.width - 20) / 9,
                  height: (MediaQuery.of(context).size.width - 20) / 9,
                  child: CustomPaint(painter: squares[i][j])
              ),
              onTap: () {
                squareSelect(squares[i][j]);
              },
            )
        );
      }
    }
    return rows;
  }
}

