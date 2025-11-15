import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// App color scheme
class AppColors {
  static const Color text = Color(0xFF212529);
  static const Color card = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFF6BCB77);
  static const Color primary = Color(0xFF3A6EA5);
  static const Color secondary = Color(0xFFFF6B6B);
  static const Color background = Color(0xFFF8F9FA);
  static const Color subduedText = Color(0xFF6C757D);

  static final ColorScheme colorScheme = ColorScheme.fromSwatch().copyWith(
    secondary: AppColors.secondary,
    surface: AppColors.card,
    primary: AppColors.primary,
    secondaryContainer: AppColors.secondary,
    onSecondaryContainer: AppColors.card,
    tertiary: AppColors.accent,
    onTertiary: AppColors.text,
    onSurface: AppColors.text,
    onPrimary: AppColors.card,
  );

  static const TextTheme textTheme = TextTheme(
    bodyMedium: TextStyle(color: AppColors.text),
    bodySmall: TextStyle(color: AppColors.subduedText),
    titleLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
  );

  static const AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.card,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.card),
    titleTextStyle: TextStyle(
      color: AppColors.card,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );

  static final ElevatedButtonThemeData elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.card,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static final InputDecorationTheme inputDecorationTheme =
      InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: AppColors.card,
  );

  static final CardThemeData cardTheme = CardThemeData(
    elevation: 2,
    color: AppColors.card,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  static final ThemeData theme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    colorScheme: AppColors.colorScheme,
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.card,
    textTheme: AppColors.textTheme,
    appBarTheme: AppColors.appBarTheme,
    elevatedButtonTheme: AppColors.elevatedButtonTheme,
    inputDecorationTheme: inputDecorationTheme,
    cardTheme: cardTheme,
  );
}

/// App theme configuration
class AppTheme {
  // Light Theme using custom colors
  static ThemeData get lightTheme => AppColors.theme;

  // Dark Theme (can be customized later)
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Theme Controller for switching themes
  static void changeTheme() {
    Get.changeThemeMode(
      Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
    );
  }
}
