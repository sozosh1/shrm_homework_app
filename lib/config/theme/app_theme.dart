import 'package:flutter/material.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryGreen,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.lightGreenBackground,
        onPrimaryContainer: AppColors.textDark,
        secondary: AppColors.lightBackground,
        onSecondary: AppColors.textDark,
        surface: AppColors.white,
        onSurface: AppColors.textDark,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: true,
      ),
      dividerTheme: DividerThemeData(color: Colors.grey),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        elevation: 0,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.lightGreenBackground,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(color: AppColors.textDark),
        ),
      ),

      listTileTheme: ListTileThemeData(
        leadingAndTrailingTextStyle: TextStyle(
          fontSize: 16,
          color: AppColors.textDark,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textDark, fontSize: 16),
        labelLarge: TextStyle(fontSize: 20),
        bodyMedium: TextStyle(fontSize: 12),
        titleLarge: TextStyle(color: AppColors.textDark, fontSize: 24),
      ),

      iconTheme: const IconThemeData(color: AppColors.textDark),
    );
  }
}
