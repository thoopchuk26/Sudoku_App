import 'dart:collection';

import 'package:sudoku_app/solver/sudokuCell.dart';

/* The original plan was to code this based around a functional pearl by Richard Bird
   Here: https://www.cs.tufts.edu/~nr/cs257/archive/richard-bird/sudoku.pdf
   But converting this code into non-haskell code was a very daunting task and I
   couldn't figure out some of the very challenging function composition issues.
   I used https://medium.com/@nikhilheda96/sudoku-solver-in-flutter-understanding-flutter-state-management-by-example-part-2-4ef78fe5d815
   instead as a basis for my code.
*/

class Solver {
  void findPossibilities(SudokuCell cell, List<List<int>> board) {
    rowPossibilities(cell, board);
    colPossibilities(cell, board);
    regionPossibilities(cell, board);
  }

  void rowPossibilities(SudokuCell cell, List<List<int>> board) {
    for (int i = 0; i < board.length; i++) {
      if (board[cell.row][i] != 0)
        cell.setPossibility(false, board[cell.row][i]);
    }
  }
  void colPossibilities(SudokuCell cell, List<List<int>> board) {
    for (int i = 0; i < board.length; i++) {
      if (board[i][cell.col] != 0)
        cell.setPossibility(false, board[i][cell.col]);
    }
  }

  void regionPossibilities(SudokuCell cell, List<List<int>> board) {
    int xRegion = (cell.row/3).truncate().toInt();
    int yRegion = (cell.col/3).truncate().toInt();
    for (int x = xRegion * 3; x < xRegion * 3 + 3; x++) {
      for (int y = yRegion * 3; y < yRegion * 3 + 3; y++) {
        if (board[x][y] != 0) cell.setPossibility(false, board[x][y]);
      }
    }
  }
  Map<String, int> getNextEmptyCell(List<List<int>> board) {
    for (int i = 0; i < board.length; i++)
      for (int j = 0; j < board.length; j++)
        if (board[i][j] == 0) return {'row': i, 'col': j};
    return null;
  }

  List<List<int>> solveSudoku(List<List<int>> board) {
    if (getNextEmptyCell(board) != null) {
      Queue<SudokuCell> cellStack = Queue<SudokuCell>();
      Map<String, int> nextEmptyCell = this.getNextEmptyCell(board);
      SudokuCell current = SudokuCell(
        row: nextEmptyCell['row'], col: nextEmptyCell['col'], board: board,);
      while (true) {
        this.findPossibilities(current, board);
        if (current.getNumberOfChoices() == 0) {
          current = cellStack.removeLast();
          current.setPossibility(
            false,
            current.getBoardNumber(current.row, current.col),
          );
          current.setBoardCell(
            current.row,
            current.col,
            0,
          );
          board = current.getBoard();
        } else {
          current.setBoardCell(
            current.row,
            current.col,
            current.getPossible()[0],
          );
          cellStack.addLast(current);
          board = current.getBoard();
          nextEmptyCell = this.getNextEmptyCell(board);
          if (nextEmptyCell == null) break;
          current = new SudokuCell(row: nextEmptyCell['row'],
            col: nextEmptyCell['col'],
            board: board,);
        }
      }
      return board;
    }
    return board;
  }
}