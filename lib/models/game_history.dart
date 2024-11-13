import 'package:four_in_a_row/models/game_board.dart';
import 'package:four_in_a_row/models/marble.dart';

class GameHistory {
  final Player player;
  final GameBoard boardState;

  GameHistory({required this.player, required this.boardState});
}
