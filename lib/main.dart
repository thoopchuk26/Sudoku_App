import 'package:flutter/material.dart';
import 'difficulty.dart';
import 'sudoku.dart';

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
  Sudoku sudoku = new Sudoku(Difficulty.EASY);

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
                //disabledHint: Text('Oi bruv, you done messed up'),
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
            Text('$boardDisplay'),
          ],
        )
      ),
    );
  }
}

