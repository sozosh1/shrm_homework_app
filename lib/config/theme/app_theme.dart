import 'package:flutter/material.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryGreen,
        onPrimary: Colors.white,
        primaryContainer: AppColors.lightGreenBackground,
        onPrimaryContainer: AppColors.textDark,
        secondary: AppColors.lightPurpleBackground,
        onSecondary: AppColors.textDark,
        surface: AppColors.whiteBackground,
        onSurface: AppColors.textDark,
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
        indicatorColor: AppColors.lightGreenBackground,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(color: AppColors.textDark),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textDark),
        titleLarge: TextStyle(color: AppColors.textDark),
      ),
      iconTheme: const IconThemeData(color: AppColors.textDark),
    );
  }
}
