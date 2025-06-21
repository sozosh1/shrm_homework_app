import 'package:flutter/material.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryGreen, // Green app bar and FAB
        onPrimary: Colors.white, // Text/icon color on primary
        primaryContainer:
            AppColors.lightGreenBackground, // Light green for backgrounds
        onPrimaryContainer:
            AppColors.textDark, // Text on light green background
        secondary:
            AppColors
                .lightPurpleBackground, // Secondary background (e.g., income screen)
        onSecondary: AppColors.textDark, // Text on secondary background
        surface: AppColors.whiteBackground, // Main content background
        onSurface: AppColors.textDark, // Text on white background
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.whiteBackground,
        indicatorColor: AppColors.lightGreenBackground, // Light green indicator
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(color: AppColors.textDark), // Dark text for labels
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textDark), // Main text
        titleLarge: TextStyle(color: AppColors.textDark), // Section titles
      ),
      iconTheme: const IconThemeData(color: AppColors.textDark), // Icons color
    );
  }
}
