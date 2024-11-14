import 'dart:async';

import 'package:flutter/material.dart';
import 'package:four_in_a_row/constants/game_state_enums.dart';
import 'package:four_in_a_row/models/game_board.dart';
import 'package:four_in_a_row/models/game_history.dart';
import 'package:four_in_a_row/models/marble.dart';
import 'package:four_in_a_row/theme/app_theme.dart';
import 'package:four_in_a_row/utils/game_history.dart';
import 'package:four_in_a_row/utils/game_timer.dart';
import 'package:four_in_a_row/widgets/draggable_marble.dart';
import 'package:four_in_a_row/widgets/game_cell.dart';
import 'package:four_in_a_row/widgets/gradient_element.dart';
import 'package:four_in_a_row/widgets/timer_widget.dart';
import 'package:go_router/go_router.dart';

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
  int timeLeft = 10;
  // Timer? timer;
  List<List<GameHistory>> gameHistory = [];
  late GameTimerUtils gameTimer;

  @override
  void initState() {
    super.initState();
    GameHistoryUtils.loadGames().then((loadedHistory) {
      setState(() {
        gameHistory = loadedHistory;
      });
      startGame();
    });
  }

  void startGame() {
    setState(() {
      gameState = GameState.playing;
      gameBoard = GameBoard();
      currentPlayer = Player.player1;
      gameWon = false;
      gameHistory.add([]);
      timeLeft = 10;
    });
    gameTimer = GameTimerUtils(
      onTick: (newTime) => setState(() => timeLeft = newTime),
      onTimeout: () => setState(() {
        currentPlayer =
            currentPlayer == Player.player1 ? Player.player2 : Player.player1;
        timeLeft = 10;
        gameTimer.start();
      }),
    );
  }

  void _onCellTapped(int row, int col) {
    if (gameWon || !gameBoard.placeMarble(row, col, Marble(currentPlayer))) {
      return;
    }

    setState(() {
      gameWon = gameBoard.checkWin();
    });

    saveMoveToHistory();

    if (gameWon && gameBoard.winningPlayer != null) {
      showGameEndDialog();
      // return;
    } else {
      setState(() {
        currentPlayer =
            currentPlayer == Player.player1 ? Player.player2 : Player.player1;
      });
      gameTimer.start();

      Future.delayed(const Duration(milliseconds: 300), () {
        if (!gameWon) {
          setState(() {
            gameBoard.rotateCounterClockwise();
          });
        }
      }).then((_) {
        setState(() {
          gameWon = gameBoard.checkWin();
        });

        if (gameWon && gameBoard.winningPlayer != null) {
          showGameEndDialog();
          // return;
        }
      });
    }
  }

  void saveMoveToHistory() {
    if (gameHistory.isNotEmpty) {
      gameHistory.last.add(
        GameHistory(player: currentPlayer, boardState: gameBoard.clone()),
      );
      GameHistoryUtils.saveGamesToLocalStorage(gameHistory);
    }
  }

  @override
  void dispose() {
    gameTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Hero(
          tag: 'marbleGameTitle',
          child: GradientElement(
            child: Text(
              'Marble Game',
              style: context.theme.textTheme.titleMedium,
            ),
          ),
        ),
        backgroundColor: context.theme.scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TimerDisplayWidget(
                timeLeft: timeLeft, currentPlayer: currentPlayer),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DraggableMarbleWidget(
                    player: Player.player2, currentPlayer: currentPlayer),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, index) {
                  final row = index ~/ 4;
                  final col = index % 4;
                  return GameCellWidget(
                      row: row,
                      col: col,
                      marble: gameBoard.board[row][col],
                      onCellTapped: _onCellTapped);
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
                DraggableMarbleWidget(
                    player: Player.player1, currentPlayer: currentPlayer),
                IconButton(
                    onPressed: () {
                      context.push('/history-screen');
                    },
                    icon: const Icon(Icons.history))
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showGameEndDialog() {
    showDialog(
      context: context,
      builder: (context) {
        gameTimer.cancel();
        return AlertDialog(
          title: Text(
            'Player ${gameBoard.winningPlayer == Player.player1 ? '1' : '2'} wins!',
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
                context.pop();
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
}
