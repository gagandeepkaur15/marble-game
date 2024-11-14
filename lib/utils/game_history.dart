import 'dart:convert';

import 'package:four_in_a_row/models/game_board.dart';
import 'package:four_in_a_row/models/game_history.dart';
import 'package:four_in_a_row/models/marble.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameHistoryUtils{
  static Future<void> saveGamesToLocalStorage(List<List<GameHistory>> gameHistory) async {
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

  static Future<List<List<GameHistory>>> loadGames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedGames = prefs.getStringList('gameHistory');

    if (savedGames != null && savedGames.isNotEmpty) {
      return savedGames.map((gameJson) {
        List<dynamic> gameHistory = jsonDecode(gameJson);
        return gameHistory.map((gameHistoryData) {
          final player = gameHistoryData['player'] == 'Player.player1'
              ? Player.player1
              : Player.player2;
          final boardState = GameBoard.fromJson(gameHistoryData['board']);
          return GameHistory(player: player, boardState: boardState);
        }).toList();
      }).toList();
    }
    return [];
  }
}