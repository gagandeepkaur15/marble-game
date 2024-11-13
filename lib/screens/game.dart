import 'package:flutter/material.dart';
import 'package:four_in_a_row/constants/game_state_enums.dart';
import 'package:four_in_a_row/models/game_board.dart';
import 'package:four_in_a_row/models/marble.dart';
import 'package:four_in_a_row/constants/theme/app_theme.dart';

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
              'Player ${currentPlayer == Player.player1 ? "1" : "2"} wins!'),
          content: const Text(
              'Would you like to restart the game or go back to the main menu?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
              child: const Text('Restart Game'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  gameState = GameState.start;
                });
              },
              child: const Text('Main Menu'),
            ),
          ],
        );
      },
    );
  }

  Widget buildCell(int row, int col) {
    final marble = gameBoard.board[row][col];
    return GestureDetector(
      onTap: () {
        _onCellTapped(row, col);
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              context.theme.primaryColor,
              context.theme.highlightColor,
            ],
          ),
        ),
        padding: const EdgeInsets.all(4),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                context.theme.primaryColor,
                context.theme.highlightColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
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
                children: [
                  if (gameWon)
                    Text(
                        'Player ${currentPlayer == Player.player1 ? "1" : "2"} wins!',
                        style: context.theme.textTheme.titleMedium),
                  SizedBox(
                    height: 400,
                    width: 400,
                    child: GridView.builder(
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
                  Text(
                    'Player ${currentPlayer == Player.player1 ? "1" : "2"}\'s turn',
                    style: context.theme.textTheme.labelMedium,
                  ),
                ],
              ),
      ),
    );
  }
}
