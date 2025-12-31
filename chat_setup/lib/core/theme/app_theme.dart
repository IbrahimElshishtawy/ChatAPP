import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: AppColors.lightCard,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.lightText),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkCard,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: AppColors.darkCard,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.darkText),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.secondary,
      unselectedItemColor: Colors.grey,
      backgroundColor: AppColors.darkCard,
    ),
  );
}
