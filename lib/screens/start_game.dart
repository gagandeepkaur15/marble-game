import 'package:flutter/material.dart';
import 'package:four_in_a_row/theme/app_theme.dart';
import 'package:four_in_a_row/widgets/gradient_element.dart';
import 'package:go_router/go_router.dart';

class StartGame extends StatelessWidget {
  const StartGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        title: GestureDetector(
          onTap: () {
            context.push('/history-screen');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "View game history",
                style: context.theme.textTheme.bodySmall,
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.history,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hero widget for a subtle animation
            Hero(
              tag: 'marbleGameTitle',
              child: GradientElement(
                child: Text(
                  "MarbleGame",
                  style: context.theme.textTheme.titleLarge,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                context.push("/game-screen");
              },
              child: const Text("Start Game"),
            ),
          ],
        ),
      ),
    );
  }
}
