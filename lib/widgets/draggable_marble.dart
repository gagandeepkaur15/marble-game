import 'package:flutter/material.dart';
import 'package:four_in_a_row/models/marble.dart';

class DraggableMarbleWidget extends StatefulWidget {
  final Player player;
  final Player currentPlayer;
  final bool isJumping;

  const DraggableMarbleWidget(
      {super.key,
      required this.player,
      required this.currentPlayer,
      this.isJumping = false});

  @override
  State<DraggableMarbleWidget> createState() => _DraggableMarbleWidgetState();
}

class _DraggableMarbleWidgetState extends State<DraggableMarbleWidget>
    with SingleTickerProviderStateMixin {
  bool _jumpUp = true;

  @override
  Widget build(BuildContext context) {
    // AbsorbPointer to prevent any pointer events if its not current player's turn
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      padding:
          EdgeInsets.only(bottom: widget.isJumping && _jumpUp ? 20.0 : 0.0),
      onEnd: () {
        if (widget.isJumping) {
          setState(() => _jumpUp = !_jumpUp);
        }
      },
      child: AbsorbPointer(
        absorbing: widget.currentPlayer != widget.player,
        // Draggable for the dragging feature of the marble
        child: Draggable<Player>(
          data: widget.currentPlayer,
          feedback: _marbleIcon(widget.player, context),
          childWhenDragging: Opacity(
            opacity: 0.5,
            child: _marbleIcon(widget.player, context),
          ),
          child: _marbleIcon(widget.player, context),
        ),
      ),
    );
  }

  // Design of the marble
  Widget _marbleIcon(Player player, BuildContext context) {
    Color color = player == Player.player1 ? Colors.blue : Colors.purple;
    return Icon(Icons.circle, color: color, size: 40);
  }
}
