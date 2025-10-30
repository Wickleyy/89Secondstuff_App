import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Warna Light Mode (Retro & Playful)
  static const Color lightPrimary = Color(0xFFD2691E); // Burnt Orange
  static const Color lightSupport = Color(0xFF008080); // Teal
  static const Color lightBackground = Color(0xFFFFF5E1); // Cream
  static const Color lightSurface = Colors.white;
  static const Color lightOnText = Color(0xFF3E2723); // Dark Brown

  // Warna Dark Mode (Minimalist Urban Streetwear)
  static const Color darkPrimary = Color(0xFF2E2E2E); // Graphite Gray
  static const Color darkAccent = Color(0xFF007AFF); // Electric Blue
  static const Color darkBackground = Color(0xFF1C1C1C); // Charcoal Black
  static const Color darkSurface = Color(0xFF2E2E2E);
  static const Color darkOnText = Color(0xFFFFFFFF); // White

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBackground,
    colorScheme: const ColorScheme.light(
      primary: lightPrimary,
      secondary: lightSupport,
      surface: lightSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: lightOnText,
      error: Colors.redAccent,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: lightOnText),
      titleTextStyle: GoogleFonts.poppins(
        color: lightOnText,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: lightOnText,
      displayColor: lightOnText,
    ),
    // --- FIX: Menggunakan CardThemeData ---
    cardTheme: CardThemeData(
      color: lightSurface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: lightSurface,
      selectedItemColor: lightPrimary,
      unselectedItemColor: lightOnText.withOpacity(0.6),
      type: BottomNavigationBarType.fixed,
      elevation: 5,
    ),
    drawerTheme: DrawerThemeData(backgroundColor: lightBackground),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkAccent,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: darkAccent,
      secondary: darkAccent,
      surface: darkSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: darkOnText,
      error: Colors.redAccent,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: darkOnText),
      titleTextStyle: GoogleFonts.poppins(
        color: darkOnText,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: darkOnText,
      displayColor: darkOnText,
    ),
    // --- FIX: Menggunakan CardThemeData ---
    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: darkAccent,
      unselectedItemColor: darkOnText.withOpacity(0.6),
      type: BottomNavigationBarType.fixed,
      elevation: 5,
    ),
    drawerTheme: DrawerThemeData(backgroundColor: darkSurface),
  );
}
