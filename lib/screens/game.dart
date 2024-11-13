import 'package:flutter/material.dart';
import 'package:four_in_a_row/constants/game_state_enums.dart';
import 'package:four_in_a_row/models/game_board.dart';
import 'package:four_in_a_row/models/marble.dart';
import 'package:four_in_a_row/theme/app_theme.dart';
import 'package:four_in_a_row/widgets/gradient_element.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameBoard gameBoard = GameBoard();
  Player currentPlayer = Player.player1;
  bool gameWon = false;
  GameState gameState = GameState.start;

  void startGame() {
    setState(() {
      gameState = GameState.playing;
      gameBoard = GameBoard();
      currentPlayer = Player.player1;
      gameWon = false;
    });
  }

  void _onCellTapped(int row, int col) {
    if (gameWon || !gameBoard.placeMarble(row, col, Marble(currentPlayer))) {
      return;
    }

    setState(() {
      gameWon = gameBoard.checkWin(currentPlayer);
    });

    if (gameWon) {
      showGameEndDialog();
      // return;
    } else {
      setState(() {
        if (!gameWon) {
          currentPlayer =
              currentPlayer == Player.player1 ? Player.player2 : Player.player1;
        }
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        if (!gameWon) {
          setState(() {
            gameBoard.rotateCounterClockwise();
          });
        }
      }).then((_) {
        setState(() {
          gameWon = gameBoard.checkWin(currentPlayer);
        });

        if (gameWon) {
          showGameEndDialog();
          // return;
        }
      });
    }
  }

  void showGameEndDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Player ${currentPlayer == Player.player1 ? "1" : "2"} wins!',
            style: context.theme.textTheme.titleMedium,
          ),
          content: Text(
            'Would you like to restart the game or go back to the main menu?',
            style: context.theme.textTheme.labelSmall,
          ),
          backgroundColor: context.theme.dialogBackgroundColor,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
              child: GradientElement(
                  child: Text(
                'Restart Game',
                style: context.theme.textTheme.labelMedium,
              )),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  gameState = GameState.start;
                });
              },
              child: GradientElement(
                  child: Text(
                'Main Menu',
                style: context.theme.textTheme.labelMedium,
              )),
            ),
          ],
        );
      },
    );
  }

  // Widget buildCell(int row, int col) {
  //   final marble = gameBoard.board[row][col];
  //   return GestureDetector(
  //     onTap: () {
  //       _onCellTapped(row, col);
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         gradient: LinearGradient(
  //           colors: [
  //             context.theme.primaryColor,
  //             context.theme.highlightColor,
  //           ],
  //         ),
  //       ),
  //       padding: const EdgeInsets.all(4),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           color: marble == null
  //               ? context.theme.scaffoldBackgroundColor
  //               : (marble.player == Player.player1
  //                   ? Colors.blue
  //                   : Colors.purple),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget buildCell(int row, int col) {
    final marble = gameBoard.board[row][col];
    return DragTarget<Player>(
      onAccept: (player) {
        if (currentPlayer == player) {
          _onCellTapped(row, col);
        }
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: marble == null
                ? LinearGradient(
                    colors: [
                      context.theme.primaryColor,
                      context.theme.highlightColor,
                    ],
                  )
                : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: marble == null
                  ? context.theme.scaffoldBackgroundColor
                  : (marble.player == Player.player1
                      ? Colors.blue
                      : Colors.purple),
            ),
          ),
        );
      },
    );
  }

  Widget buildDraggableMarble1() {
    return AbsorbPointer(
      absorbing: currentPlayer != Player.player1,
      child: Draggable<Player>(
        data: currentPlayer,
        // child remaining behind when item dragged
        feedback: Icon(
          Icons.circle,
          color: currentPlayer == Player.player1
              ? Colors.blue
              : Colors.blue.withOpacity(0.2),
          size: 40,
        ),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: Icon(
            Icons.circle,
            color: currentPlayer == Player.player1
                ? Colors.blue
                : Colors.blue.withOpacity(0.2),
            size: 40,
          ),
        ),
        child: Icon(
          Icons.circle,
          color: currentPlayer == Player.player1
              ? Colors.blue
              : Colors.blue.withOpacity(0.2),
          size: 40,
        ),
      ),
    );
  }

  Widget buildDraggableMarble2() {
    return AbsorbPointer(
      absorbing: currentPlayer != Player.player2,
      child: Draggable<Player>(
        data: currentPlayer,
        // child remaining behind when item dragged
        feedback: Icon(
          Icons.circle,
          color: currentPlayer == Player.player1
              ? Colors.purple.withOpacity(0.2)
              : Colors.purple,
          size: 40,
        ),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: Icon(
            Icons.circle,
            color: currentPlayer == Player.player1
                ? Colors.purple.withOpacity(0.2)
                : Colors.purple,
            size: 40,
          ),
        ),
        child: Icon(
          Icons.circle,
          color: currentPlayer == Player.player1
              ? Colors.purple.withOpacity(0.2)
              : Colors.purple,
          size: 40,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GradientElement(
          child: Text(
            'Marble Game',
            style: context.theme.textTheme.titleMedium,
          ),
        ),
        backgroundColor: context.theme.scaffoldBackgroundColor,
      ),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: gameState == GameState.start
            ? Center(
                child: ElevatedButton(
                  onPressed: startGame,
                  child: const Text('Start Game'),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildDraggableMarble2(),
                      const SizedBox(width: 20),
                      Transform.rotate(
                        angle: 3.14159, // pie value (radians)
                        child: Text(
                          currentPlayer == Player.player2 ? "Your turn" : "",
                          style: context.theme.textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4),
                      itemBuilder: (context, index) {
                        final row = index ~/ 4;
                        final col = index % 4;
                        return buildCell(row, col);
                      },
                      itemCount: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Text(
                        currentPlayer == Player.player1 ? "Your turn" : "",
                        style: context.theme.textTheme.labelMedium,
                      ),
                      const SizedBox(width: 20),
                      buildDraggableMarble1(),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
