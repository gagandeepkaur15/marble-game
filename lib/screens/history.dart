import 'package:flutter/material.dart';
import 'package:four_in_a_row/models/game_board.dart';
import 'package:four_in_a_row/models/game_history.dart';
import 'package:four_in_a_row/models/marble.dart';
import 'package:four_in_a_row/theme/app_theme.dart';
import 'package:four_in_a_row/utils/game_history.dart';
import 'package:four_in_a_row/widgets/gradient_element.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<List<GameHistory>> gameHistory = [];

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  // Load previous games from local storage
  Future<void> _loadGames() async {
    final loadedHistory = await GameHistoryUtils.loadGames();
    setState(() {
      gameHistory = loadedHistory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
            ),
            Text(
              'Game History',
              style: context.theme.textTheme.titleMedium,
            ),
          ],
        ),
        foregroundColor: Colors.white,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        actions: [
          // Delete History
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('gameHistory');
              setState(() {
                gameHistory.clear();
              });
            },
          ),
        ],
      ),
      body: gameHistory.isEmpty
          ? Center(
              child: Text(
              "No game history available.",
              style: context.theme.textTheme.labelMedium,
            ))
          : ListView.builder(
              itemCount: gameHistory.length,
              itemBuilder: (context, gameIndex) {
                final gameNumber = gameIndex + 1;
                final gameData = gameHistory[gameIndex];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GradientElement(
                        child: Text(
                          'Game $gameNumber',
                          style: context.theme.textTheme.titleMedium,
                        ),
                      ),
                    ),
                    ...gameData.map((game) => ListTile(
                          title: Text(
                            'Player ${game.player == Player.player1 ? '1' : '2'}',
                            style: context.theme.textTheme.bodyMedium,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 90),
                            child: buildBoardGrid(game.boardState),
                          ),
                        )),
                    const Divider(),
                  ],
                );
              },
            ),
    );
  }

  // Showing previous moves in 4x4 grid
  Widget buildBoardGrid(GameBoard boardState) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemCount: 16,
        itemBuilder: (context, index) {
          final row = index ~/ 4;
          final col = index % 4;
          final marble = boardState.board[row][col];

          return Container(
            decoration: BoxDecoration(
              color: marble == null
                  ? Colors.grey[200]
                  : (marble.player == Player.player1
                      ? Colors.blue
                      : Colors.purple),
              border: Border.all(color: Colors.black12),
            ),
            child: Center(
              child: marble == null
                  ? const Text("")
                  : Text(
                      marble.player == Player.player1 ? "1" : "2",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
