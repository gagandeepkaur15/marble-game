import 'package:flutter/material.dart';
import 'package:four_in_a_row/routes/routes.dart';
import 'package:four_in_a_row/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Marble Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
      ),
      // Routes
      routerConfig: router,
    );
  }
}
