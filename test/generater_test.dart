import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_app/sudoku.dart';
import 'package:sudoku_app/difficulty.dart';

void main() {
  test("test board generation",(){
    Sudoku sudoku = new Sudoku(Difficulty.EASY);
    sudoku.fillValues();
    int numSpaces = 0;
    for(int i = 0;i<sudoku.board.length;i++){
      for(int j = 0;j<sudoku.board.length;j++){
        if(sudoku.board[i][j] is int){
          numSpaces++;
        }
      }
    }
    expect(numSpaces, 81);//check for correct number of spaces in 9x9 board
  });
  test("test easy board generation",(){
    Sudoku sudoku = new Sudoku(Difficulty.EASY);
    sudoku.fillValues();
    int numZeroes = 0;
    for(int i = 0;i<sudoku.board.length;i++){
      for(int j = 0;j<sudoku.board.length;j++){
        if(sudoku.board[i][j] == 0)
          numZeroes++;
      }
    }
    expect(numZeroes, 41);//check for correct number of empty spaces in board
  });
  test("test medium board generation",(){
    Sudoku sudoku = new Sudoku(Difficulty.MEDIUM);
    sudoku.fillValues();
    int numZeroes = 0;
    for(int i = 0;i<sudoku.board.length;i++){
      for(int j = 0;j<sudoku.board.length;j++){
        if(sudoku.board[i][j] == 0)
          numZeroes++;
      }
    }
    expect(numZeroes, 51);//check for correct number of empty spaces in board
  });
  test("test hard board generation",(){
    Sudoku sudoku = new Sudoku(Difficulty.HARD);
    sudoku.fillValues();
    int numZeroes = 0;
    for(int i = 0;i<sudoku.board.length;i++){
      for(int j = 0;j<sudoku.board.length;j++){
        if(sudoku.board[i][j] == 0)
          numZeroes++;
      }
    }
    expect(numZeroes, 61);//check for correct number of empty spaces in board
  });
}