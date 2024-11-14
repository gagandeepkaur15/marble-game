import 'package:flutter/material.dart';
import 'package:four_in_a_row/models/marble.dart';
import 'package:four_in_a_row/theme/app_theme.dart';

class GameCellWidget extends StatelessWidget {
  final int row;
  final int col;
  final Marble? marble;
  final Function(int, int) onCellTapped;

  const GameCellWidget(
      {super.key,
      required this.row,
      required this.col,
      this.marble,
      required this.onCellTapped});

  @override
  Widget build(BuildContext context) {
    return DragTarget<Player>(
      // When player places marble on the target
      onAccept: (player) => onCellTapped(row, col),
      // Building UI of the widget
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
                  : (marble?.player == Player.player1
                      ? Colors.blue
                      : Colors.purple),
            ),
          ),
        );
      },
    );
  }
}
