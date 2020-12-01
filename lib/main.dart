import 'package:flutter/material.dart';
import 'package:sudoku_app/Square.dart';
import 'difficulty.dart';
import 'sudoku.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
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
            RaisedButton(
              child: Text('Solve Board'),
              onPressed: () {
              },
            )
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
    // sudoku.printSudoku();
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
    //print(sudoku.board[8][0]);
    print(boardDisplay);
    print(diff);
    for(int i = 0; i <= 3; i++){
      print('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Play Sudoku'),
      ),
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
              child: Text('Generate Sudoku Grid'),
              onPressed: () {
                displayBoard();
                setState(() {
                });
              },
              ),
            RaisedButton(
              child: Text('Go to Sudoku'),
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
  // Either use this or do "final int size like in boggle"


  @override
  _SudokuGridPageState createState() => _SudokuGridPageState();
}

class _SudokuGridPageState extends State<SudokuGridPage> {

  List<List<Square>> squares = new List<List<Square>>();
  int number = 0;

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
    List<List<Widget>> rows = getRows();
    for(int i = 0; i < 9; i ++){
      body.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: rows[i],));
    }
    body.add(RaisedButton(
      child: Text('Update'),
      onPressed: () {
        setState(() {
        });
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
        title: Text('Sudoku Visualization'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: body,
        ),
      ),
    );
  }

  List<List<Widget>> getRows() {
    List<List<Widget>> rows = new List<List<Widget>>();
    for (int i=0; i < 9; i++) {
      squares.add(new List<Square>());
      rows.add(new List<Widget>());
      for (int j=0; j < 9; j++) {
        squares[i].add(new  Square(widget.sudoku.board[i][j]));
        rows[i].add(
            GestureDetector( // figured this out at https://stackoverflow.com/questions/57100266/how-do-i-get-to-tap-on-a-custompaint-path-in-flutter-using-gesturedetect
              child: Container(
                  width: (MediaQuery.of(context).size.width - 20) / 9, // figured out how to get screen size at https://flutter.dev/docs/development/ui/layout/responsive
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
