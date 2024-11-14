import 'package:flutter/material.dart';
import 'package:four_in_a_row/models/marble.dart';
import 'package:four_in_a_row/theme/app_theme.dart';

class TimerDisplayWidget extends StatelessWidget {
  final int timeLeft;
  final Player currentPlayer;

  const TimerDisplayWidget(
      {super.key, required this.timeLeft, required this.currentPlayer});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Time left: $timeLeft s',
      style: context.theme.textTheme.labelMedium?.copyWith(
        color: currentPlayer == Player.player1 ? Colors.blue : Colors.purple,
      ),
    );
  }
}
