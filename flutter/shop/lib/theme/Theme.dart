import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  // --- ЦВЕТА ---
  static const Color _lightPrimaryColor = Color(0xFF007AFF);
  static const Color _lightBackgroundColor = Color(0xFFF2F2F7);
  static const Color _lightSurfaceColor = Colors.white;
  static const Color _lightOnSurfaceColor = Color(0xFF1C1C1E);

  static const Color _darkPrimaryColor = Color(0xFF0A84FF);
  static const Color _darkBackgroundColor = Colors.black;
  static const Color _darkSurfaceColor = Color(0xFF1C1C1E);
  static const Color _darkOnSurfaceColor = Color(0xFFE5E5EA);
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Helvetica',
    primaryColor: _lightPrimaryColor,
    scaffoldBackgroundColor: _lightBackgroundColor,
    
    // Схема цветов
    colorScheme: const ColorScheme.light(
      primary: _lightPrimaryColor,
      onPrimary: Colors.white,
      secondary: _lightPrimaryColor,
      onSecondary: Colors.white,
      background: _lightBackgroundColor,
      onBackground: _lightOnSurfaceColor,
      surface: _lightSurfaceColor,
      onSurface: _lightOnSurfaceColor,
      error: Colors.redAccent,
      onError: Colors.white,
    ),

    // Тема для AppBar
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: _lightBackgroundColor,
      foregroundColor: _lightOnSurfaceColor,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark, // Темные иконки в статус-баре
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _lightOnSurfaceColor,
      ),
    ),

    // Тема для карточек
    cardTheme: CardThemeData(
      elevation: 0,
      color: _lightSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),

    // Тема для кнопок
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),

    // Тема для полей ввода
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      hintStyle: TextStyle(
        color: Colors.black26
      ),
      fillColor: _lightSurfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: _lightPrimaryColor, width: 2.0),
      ),
    ),

    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 40
      ),
      bodyMedium: TextStyle(
        fontSize: 35
      ),
      bodySmall: TextStyle(
        fontSize: 25
      ),

      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 60
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 35
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25
      ),
    ),
  );

  /// Тёмная тема в стиле Apple
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'SFPro',
    primaryColor: _darkPrimaryColor,
    scaffoldBackgroundColor: _darkBackgroundColor,

    // Схема цветов
    colorScheme: const ColorScheme.dark(
      primary: _darkPrimaryColor,
      onPrimary: Colors.white,
      secondary: _darkPrimaryColor,
      onSecondary: Colors.white,
      background: _darkBackgroundColor,
      onBackground: _darkOnSurfaceColor,
      surface: _darkSurfaceColor,
      onSurface: _darkOnSurfaceColor,
      error: Colors.redAccent,
      onError: Colors.white,
    ),

    // Тема для AppBar
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: _darkBackgroundColor,
      foregroundColor: _darkOnSurfaceColor,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light, // Светлые иконки в статус-баре
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _darkOnSurfaceColor,
      ),
    ),

    // Тема для карточек
    cardTheme: CardThemeData(
      elevation: 0,
      color: _darkSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),

    // Тема для кнопок
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),

    // Тема для полей ввода
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      hintStyle: TextStyle(
        color: Colors.white24
      ),
      fillColor: _darkSurfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: _darkPrimaryColor, width: 2.0),
      ),
    ),

    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 40
      ),
      bodyMedium: TextStyle(
        fontSize: 35
      ),
      bodySmall: TextStyle(
        fontSize: 25
      ),

      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 60
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 35
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25
      ),
    ),
  );
}