import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'constants.dart';
import 'dimensions.dart';

class AppTheme {
  late final ThemeData lightTheme;
  late final ThemeData darkTheme;

  AppTheme(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.kPrimary,
      brightness: Brightness.light,
      primary: AppColors.kPrimary,
      secondary: AppColors.kAccent,
      surface: AppColors.kSurface,
    );

    lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.kBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.kBackground,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AppColors.kPrimary,
        titleTextStyle: TextStyle(
          fontFamily: kHeadingFont,
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: AppColors.kTextPrimary,
        ),
      ),
      textTheme: _buildTextTheme(Brightness.light),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      textButtonTheme: _textButtonTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.kBackground,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: AppColors.kTextSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: CardThemeData(
        color: AppColors.kSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kMediumRadius)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.kBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kMediumRadius)),
      ),
    );

    darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme.copyWith(
        brightness: Brightness.dark,
        surface: const Color(0xFF121826),
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF0A0F1A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0A0F1A),
        elevation: 0,
        centerTitle: true,
        foregroundColor: AppColors.kAccent,
      ),
      textTheme: _buildTextTheme(Brightness.dark),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      textButtonTheme: _textButtonTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF121826),
        selectedItemColor: AppColors.kAccent,
        unselectedItemColor: Colors.white70,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF121826),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kMediumRadius)),
      ),
    );
  }

  /// --- Typography system
  TextTheme _buildTextTheme(Brightness brightness) {
    final color = brightness == Brightness.light ? AppColors.kTextPrimary : Colors.white;

    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: kHeadingFont,
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: color,
      ),
      headlineLarge: TextStyle(
        fontFamily: kHeadingFont,
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: color,
      ),
      headlineMedium: TextStyle(
        fontFamily: kHeadingFont,
        fontWeight: FontWeight.w600,
        fontSize: 22,
        color: color,
      ),
      headlineSmall: TextStyle(
        fontFamily: kHeadingFont,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: color,
      ),
      labelLarge: TextStyle(
        fontFamily: kHeadingFont,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: color,
      ),
      bodyLarge: TextStyle(
        fontFamily: kBodyFont,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: color,
      ),
      bodyMedium: TextStyle(
        fontFamily: kBodyFont,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: color.withValues(alpha: 0.9),
      ),

      bodySmall: TextStyle(
        fontFamily: kBodyFont,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: color.withValues(alpha: 0.9),
      ),
    );
  }

  /// --- Buttons
  ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme scheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kMediumRadius)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: const TextStyle(
          fontFamily: kHeadingFont,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme scheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.primary,
        side: BorderSide(color: scheme.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kMediumRadius)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    );
  }

  TextButtonThemeData _textButtonTheme(ColorScheme scheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.secondary,
        textStyle: const TextStyle(
          fontFamily: kHeadingFont,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  /// --- TextFields
  InputDecorationTheme _inputDecorationTheme(ColorScheme scheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kMediumRadius),
        borderSide: BorderSide(color: scheme.primary.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kMediumRadius),
        borderSide: BorderSide(color: scheme.primary, width: 1.5),
      ),
      labelStyle: TextStyle(color: scheme.primary, fontFamily: kBodyFont),
      hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: 0.5)),
    );
  }

  ThemeData themeData({required bool isDarkModeOn}) {
    return isDarkModeOn ? darkTheme : lightTheme;
  }
}
