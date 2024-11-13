import 'package:four_in_a_row/screens/game.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const GameScreen(),
  ),
  GoRoute(
    path: '/game-screen',
    builder: (context, state) => const GameScreen(),
  ),
  GoRoute(
    path: '/history-screen',
    builder: (context, state) => const GameScreen(),
  ),
]);
