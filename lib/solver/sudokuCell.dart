class SudokuCell {
  int row;
  int col;

  List<List<int>> board;
  List<bool> possibilities;

  SudokuCell({this.row,this.col, this.board}) {
    this.possibilities = List<bool>.filled(9,true);
  }

  int getNumberOfChoices() {
    int count = 0;
    for (int i = 0;i < 9;i++){
      if (this.possibilities[i]){
        count++;
      }
    }
    return count;
  }

  List<int> getPossible() {
    int count = this.getNumberOfChoices();
    if (count == 0){
      return null;
    }
    List<int> possible = [];
    for (int i=0;i < 9; i++){
      if (this.possibilities[i]){
        possible.add(i+1);
      }
    }
    return possible;
  }

  int getBoardNumber(int row, int col) {
    return this.board[row][col];
  }

  List<List<int>> getBoard() {
    return this.board;
  }

  void setBoardCell(int row, int col, int value) {
    this.board[row][col] = value;
  }

  void setPossibility(bool state, int number) {
    this.possibilities[number - 1] = state;
  }


}