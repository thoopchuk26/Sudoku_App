import 'dart:math';
import 'package:sudoku_app/difficulty.dart';
import 'difficulty.dart';

/*
Disclaimer:
90% of the logic in this class was taken from
https://www.geeksforgeeks.org/program-sudoku-generator/
I do not claim to have made this code from scratch
 */

class Sudoku{
  Difficulty difficulty;
  final board = List<List<int>>.generate(9, (i) => List<int>.generate(9, (j) => 0));
  Random random = new Random();

  Sudoku(this.difficulty);

  void setDiff (Difficulty diff){
    this.difficulty = diff;
  }

  void fillValues() {
    fillDiagonal();
    fillRemaining(0, 3);
    removeNumDigits();
  }

  void fillDiagonal() {
    for (int i = 0; i<9; i=i+3)
      fillBox(i, i);
  }

  bool unUsedInBox(int rowStart, int colStart, int num) {
    for (int i = 0; i<3; i++)
      for (int j = 0; j<3; j++)
        if (board[rowStart+i][colStart+j]==num)
          return false;
    return true;
  }

  void fillBox(int row,int col) {
    int num;
    bool check;
    for (int i=0; i<3; i++) {
      for (int j=0; j<3; j++) {
        do {
          num = random.nextInt(9)+1;
          check = (!unUsedInBox(row, col, num));
        }
        while (check);
        board[row+i][col+j] = num;
      }
    }
  }

  bool CheckIfSafe(int i,int j,int num) {
    return (unUsedInRow(i, num) &&
        unUsedInCol(j, num) &&
        unUsedInBox(i-i%3, j-j%3, num));
  }

  bool unUsedInRow(int i,int num) {
    for (int j = 0; j<9; j++)
      if (board[i][j] == num)
        return false;
    return true;
  }

  bool unUsedInCol(int j,int num) {
    for (int i = 0; i<9; i++)
      if (board[i][j] == num)
        return false;
    return true;
  }

  bool fillRemaining(int i, int j) {
    if (j>=9 && i<9-1) {
      i = i + 1;
      j = 0;
    }
    if (i>=9 && j>=9)
      return true;

    if (i < 3) {
      if (j < 3)
        j = 3;
    }
    else if (i < 9-3) {
      if (j==(i~/3)*3)
        j =  j + 3;
    }
    else {
      if (j == 9-3)
      {
        i = i + 1;
        j = 0;
        if (i>=9)
          return true;
      }
    }

    for (int num = 1; num<=9; num++) {
      if (CheckIfSafe(i, j, num)) {
        board[i][j] = num;
        if (fillRemaining(i, j+1))
          return true;
        board[i][j] = 0;
      }
    }
    return false;
  }

  void removeNumDigits() {
    int count;
    switch(difficulty){
      case Difficulty.EASY:
        count = 40;
      break;
      case Difficulty.MEDIUM:
        count = 50;
      break;
      case Difficulty.HARD:
        count = 60;
      break;
    }
    while (count != 0) {
      int randNum = random.nextInt(81);
      int i = (randNum~/9);
      int j = randNum%9;
      if (j != 0)
        j = j - 1;
      if (board[i][j] != 0) {
        count--;
        board[i][j] = 0;
      }
    }
  }

  String giveSudokuBoard(){
    String sboard =
    board[0].toString() + '\n' +
    board[1].toString() + '\n' +
    board[2].toString() + '\n' +
    board[3].toString() + '\n' +
    board[4].toString() + '\n' +
    board[5].toString() + '\n' +
    board[6].toString() + '\n' +
    board[7].toString() + '\n' +
    board[8].toString();
    return sboard;
  }
}