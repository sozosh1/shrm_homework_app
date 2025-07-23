import 'package:flutter/material.dart';


class AppTheme {
  static ThemeData lightTheme(Color primaryColor) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
    );
    return ThemeData.from(
      colorScheme: colorScheme,
      useMaterial3: true,
    ).copyWith(
      // Customizations here
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(colorScheme.primary),
          foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(colorScheme.primary),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStateProperty.all(BorderSide(color: colorScheme.primary)),
          foregroundColor: WidgetStateProperty.all(colorScheme.primary),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            }
            return colorScheme.surface;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.onPrimary;
            }
            return colorScheme.onSurface;
          }),
          side: WidgetStateProperty.all<BorderSide>(
            BorderSide(color: colorScheme.primary),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          padding: WidgetStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,

        elevation: 0,
        centerTitle: true,
      ),
      dividerTheme: DividerThemeData(color: colorScheme.outline),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const CircleBorder(),
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        // ignore: deprecated_member_use
        indicatorColor: colorScheme.primary.withOpacity(0.1),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(color: colorScheme.onSurface),
        ),
      ),
      listTileTheme: ListTileThemeData(
        leadingAndTrailingTextStyle: TextStyle(
          fontSize: 16,
          color: colorScheme.onSurface,
        ),
      ),
      textTheme: TextTheme(
        titleMedium: TextStyle(color: colorScheme.onSurface, fontSize: 16),
        bodyLarge: TextStyle(color: colorScheme.onSurface, fontSize: 16),
        labelLarge: TextStyle(color: colorScheme.onSurface, fontSize: 20),
        bodyMedium: TextStyle(color: colorScheme.onSurface, fontSize: 12),
        titleLarge: TextStyle(color: colorScheme.onSurface, fontSize: 24),
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
    );
  }

  static ThemeData darkTheme(Color primaryColor) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
    );
    return ThemeData.from(
      colorScheme: colorScheme,
      useMaterial3: true,
    ).copyWith(
      // Similar customizations for dark theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(colorScheme.primary),
          foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(colorScheme.primary),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStateProperty.all(BorderSide(color: colorScheme.primary)),
          foregroundColor: WidgetStateProperty.all(colorScheme.primary),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primary;
            }
            return colorScheme.surface;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.onPrimary;
            }
            return colorScheme.onSurface;
          }),
          side: WidgetStateProperty.all<BorderSide>(
            BorderSide(color: colorScheme.primary),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          padding: WidgetStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      dividerTheme: DividerThemeData(color: colorScheme.outline),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const CircleBorder(),
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.primaryContainer,
        //indicatorColor: colorScheme.primary.withOpacity(0.1),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(color: colorScheme.onSurface),
        ),
      ),
      listTileTheme: ListTileThemeData(
        leadingAndTrailingTextStyle: TextStyle(
          fontSize: 16,
          color: colorScheme.onSurface,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: colorScheme.onSurface, fontSize: 16),
        labelLarge: TextStyle(color: colorScheme.onSurface, fontSize: 20),
        bodyMedium: TextStyle(color: colorScheme.onSurface, fontSize: 12),
        titleLarge: TextStyle(color: colorScheme.onSurface, fontSize: 24),
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
    );
  }
}
