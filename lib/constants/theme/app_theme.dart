import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF0A0A0A);
  static const Color primary = Color(0xFF27FFEF);
  static const Color secondary = Color(0xFFB9FFB3);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color.fromARGB(255, 178, 177, 177);
}

extension ThemeExtension on BuildContext {
  ThemeData get theme {
    return ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        highlightColor: AppColors.secondary,
        shadowColor: AppColors.grey,
        textTheme: TextTheme(
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
        ));
  }
}
