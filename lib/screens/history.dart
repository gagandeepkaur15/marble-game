import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:four_in_a_row/models/game_board.dart';
import 'package:four_in_a_row/models/game_history.dart';
import 'package:four_in_a_row/models/marble.dart';
import 'package:four_in_a_row/screens/game.dart';
import 'package:four_in_a_row/theme/app_theme.dart';
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

  Future<void> _loadGames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedGames = prefs.getStringList('gameHistory');

    if (savedGames != null) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Game History',
          style: context.theme.textTheme.titleMedium,
        ),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        actions: [
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
          ? const Center(child: Text("No game history available."))
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
                      child: Text(
                        'Game $gameNumber',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...gameData.map((game) => ListTile(
                          title: Text(
                            'Player ${game.player == Player.player1 ? '1' : '2'}',
                          ),
                          subtitle: Text(
                            'Board State: ${jsonEncode(game.boardState.toJson())}',
                          ),
                        )),
                    const Divider(),
                  ],
                );
              },
            ),
    );
  }
}
