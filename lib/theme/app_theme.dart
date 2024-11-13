import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF0A0A0A);
  static const Color primary = Color(0xFF27FFEF);
  static const Color secondary = Color(0xFFB9FFB3);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color.fromARGB(255, 45, 45, 45);
}

extension ThemeExtension on BuildContext {
  ThemeData get theme {
    return ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        highlightColor: AppColors.secondary,
        cardColor: AppColors.grey,
        dialogBackgroundColor: AppColors.grey,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
        ),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.play(
            fontSize: 50,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          titleMedium: GoogleFonts.play(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          labelMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          labelSmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ));
  }
}
