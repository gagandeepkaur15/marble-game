import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:four_in_a_row/constants/game_state_enums.dart';
import 'package:four_in_a_row/models/game_board.dart';
import 'package:four_in_a_row/models/game_history.dart';
import 'package:four_in_a_row/models/marble.dart';
import 'package:four_in_a_row/screens/history.dart';
import 'package:four_in_a_row/theme/app_theme.dart';
import 'package:four_in_a_row/widgets/gradient_element.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Timer? timer;
  List<List<GameHistory>> gameHistory = [];

  @override
  void initState() {
    super.initState();
    _loadGames();
    startGame();
  }

  void startGame() {
    setState(() {
      gameState = GameState.playing;
      gameBoard = GameBoard();
      currentPlayer = Player.player1;
      gameWon = false;
      gameHistory.add([]);
    });
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    setState(() {
      timeLeft = 10;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        setState(() {
          currentPlayer =
              currentPlayer == Player.player1 ? Player.player2 : Player.player1;
          timeLeft = 10;
        });
      }
    });
  }

  void _onCellTapped(int row, int col) {
    if (gameWon || !gameBoard.placeMarble(row, col, Marble(currentPlayer))) {
      return;
    }

    setState(() {
      gameWon = gameBoard.checkWin(currentPlayer);
    });

    saveMoveToHistory();

    if (gameWon) {
      showGameEndDialog();
      // return;
    } else {
      setState(() {
        currentPlayer =
            currentPlayer == Player.player1 ? Player.player2 : Player.player1;
      });
      startTimer();

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

  void saveMoveToHistory() {
    if (gameHistory.isNotEmpty) {
      gameHistory.last.add(
        GameHistory(player: currentPlayer, boardState: gameBoard.clone()),
      );
      saveGamesToLocalStorage(gameHistory);
    }
  }

  Future<void> saveGamesToLocalStorage(
      List<List<GameHistory>> gameHistory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> gamesJson = gameHistory.map((game) {
      return jsonEncode(game
          .map((gameHisObj) => {
                'player': gameHisObj.player.toString(),
                'board': gameHisObj.boardState.toJson(),
              })
          .toList());
    }).toList();
    await prefs.setStringList('gameHistory', gamesJson);
  }

  Future<void> _loadGames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedGames = prefs.getStringList('gameHistory');

    if (savedGames != null && savedGames.isNotEmpty) {
      setState(() {
        gameHistory = savedGames.map((gameJson) {
          List<dynamic> gameHistory = jsonDecode(gameJson);
          return gameHistory.map((gameHistoryData) {
            final player = gameHistoryData['player'] == 'Player.player1'
                ? Player.player1
                : Player.player2;
            final boardState = GameBoard.fromJson(gameHistoryData['board']);
            return GameHistory(player: player, boardState: boardState);
          }).toList();
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
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
            buildTimerDisplay(),
            const SizedBox(height: 20),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HistoryScreen(),
                        ),
                      );
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
        timer?.cancel();
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

  Widget buildTimerDisplay() {
    return Text(
      'Time left: $timeLeft s',
      style: context.theme.textTheme.labelMedium?.copyWith(
        color: currentPlayer == Player.player1 ? Colors.blue : Colors.purple,
      ),
    );
  }
}
