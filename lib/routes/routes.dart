import 'package:four_in_a_row/screens/game.dart';
import 'package:four_in_a_row/screens/history.dart';
import 'package:four_in_a_row/screens/start_game.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const StartGame(),
  ),
  GoRoute(
    path: '/game-screen',
    builder: (context, state) => const GameScreen(),
  ),
  GoRoute(
    path: '/history-screen',
    builder: (context, state) => const HistoryScreen(),
  ),
]);
