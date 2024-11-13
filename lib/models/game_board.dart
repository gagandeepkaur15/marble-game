import 'package:four_in_a_row/models/marble.dart';

class GameBoard {
  final int size = 4;
  List<List<Marble?>> board;
  Player? winningPlayer;

  GameBoard() : board = List.generate(4, (_) => List.filled(4, null));
  GameBoard.withBoard(this.board);

  bool placeMarble(int row, int col, Marble marble) {
    if (board[row][col] == null) {
      board[row][col] = marble;
      return true;
    }
    return false;
  }

  void rotateCounterClockwise() {
    int maxRow = size - 1;
    int maxCol = size - 1;
    int row = 0;
    int col = 0;

    List<List<Marble?>> newBoard =
        List.generate(size, (_) => List.filled(size, null));

    while (row < maxRow && col < maxCol) {
      Marble? previous = board[row][col + 1];

      for (int i = row; i <= maxRow; i++) {
        Marble? current = board[i][col];
        newBoard[i][col] = previous;
        previous = current;
      }
      col++;

      for (int i = col; i <= maxCol; i++) {
        Marble? current = board[maxRow][i];
        newBoard[maxRow][i] = previous;
        previous = current;
      }
      maxRow--;

      if (col <= maxCol) {
        for (int i = maxRow; i >= row; i--) {
          Marble? current = board[i][maxCol];
          newBoard[i][maxCol] = previous;
          previous = current;
        }
        maxCol--;
      }

      if (row <= maxRow) {
        for (int i = maxCol; i >= col; i--) {
          Marble? current = board[row][i];
          newBoard[row][i] = previous;
          previous = current;
        }
        row++;
      }
    }

    board = newBoard;
  }

  bool checkWin() {
    // Traversing each row
    for (int i = 0; i < size; i++) {
      if (_isFourInARow(List.generate(size, (j) => board[i][j]))) {
        return true;
      }
    }

    // Traversing each column
    for (int j = 0; j < size; j++) {
      if (_isFourInARow(List.generate(size, (i) => board[i][j]))) {
        return true;
      }
    }

    // Traversing diagonal
    if (_isFourInARow(List.generate(size, (i) => board[i][i]))) {
      return true;
    }

    // Traversing diagonal
    if (_isFourInARow(
        List.generate(size, (i) => board[i][size - i - 1]))) {
      return true;
    }

    return false;
  }

  bool _isFourInARow(List<Marble?> line) {
    final piece = line.firstWhere(
      (e) {
        return e != null;
      },
      orElse: () => null,
    );
    if (piece == null) return false;
    final isfour = line.every((marble) {
      return marble?.player == piece.player;
    });
    if (isfour) {
      winningPlayer = piece.player;
    }
    return isfour;
  }

  GameBoard clone() {
    List<List<Marble?>> newBoard =
        board.map((row) => row.map((cell) => cell?.clone()).toList()).toList();
    return GameBoard.withBoard(newBoard);
  }

  GameBoard.fromJson(Map<String, dynamic> json)
      : board = List<List<Marble?>>.from(
          json['board'].map((row) => List<Marble?>.from(
                row.map((cell) => cell != null ? Marble.fromJson(cell) : null),
              )),
        );

  Map<String, dynamic> toJson() {
    return {
      'board': board
          .map((row) => row.map((cell) => cell?.toJson()).toList())
          .toList(),
    };
  }
}
