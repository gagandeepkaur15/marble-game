import 'package:flutter/material.dart';
import 'package:four_in_a_row/models/marble.dart';

class DraggableMarbleWidget extends StatelessWidget {
  final Player player;
  final Player currentPlayer;

  const DraggableMarbleWidget({super.key, required this.player, required this.currentPlayer});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: currentPlayer != player,
      child: Draggable<Player>(
        data: currentPlayer,
        feedback: _marbleIcon(player, context),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: _marbleIcon(player, context),
        ),
        child: _marbleIcon(player, context),
      ),
    );
  }

  Widget _marbleIcon(Player player, BuildContext context) {
    Color color = player == Player.player1 ? Colors.blue : Colors.purple;
    return Icon(Icons.circle, color: color, size: 40);
  }
}
