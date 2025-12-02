import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Deep Royal Purple Theme Colors
  static const Color deepPurpleDark = Color(0xFF1A0F2E);
  static const Color deepPurpleLight = Color(0xFF4C2A85);
  static const Color accentMustard = Color(0xFFD4A84B);
  static const Color accentRed = Color(0xFFB8354C);
  static const Color glowPurple = Color(0xFF6B4E9E);
  
  // Warna Light Mode (Deep Purple Theme)
  static const Color lightPrimary = Color(0xFF4C2A85); // Deep Purple
  static const Color lightSupport = Color(0xFFD4A84B); // Mustard Accent
  static const Color lightBackground = Color(0xFFF8F5FF); // Soft Purple Tint
  static const Color lightSurface = Colors.white;
  static const Color lightOnText = Color(0xFF1A0F2E); // Deep Purple Dark

  // Warna Dark Mode (Deep Royal Purple)
  static const Color darkPrimary = Color(0xFFD4A84B); // Mustard Accent
  static const Color darkAccent = Color(0xFFB8354C); // Red Accent
  static const Color darkBackground = Color(0xFF1A0F2E); // Deep Purple Dark
  static const Color darkSurface = Color(0xFF261847); // Slightly lighter purple
  static const Color darkOnText = Color(0xFFF8F5FF); // Light text
  
  // Gradient untuk background
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepPurpleDark, deepPurpleLight],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D1B4E), Color(0xFF1A0F2E)],
  );

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
    cardTheme: CardThemeData(
      color: lightSurface,
      elevation: 4,
      shadowColor: lightPrimary.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentMustard,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: accentMustard.withValues(alpha: 0.4),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: lightSurface,
      selectedItemColor: lightPrimary,
      unselectedItemColor: lightOnText.withValues(alpha: 0.6),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: lightBackground),
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
    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 8,
      shadowColor: glowPurple.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentMustard,
        foregroundColor: deepPurpleDark,
        elevation: 6,
        shadowColor: accentMustard.withValues(alpha: 0.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentMustard,
        side: const BorderSide(color: accentMustard, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: accentMustard,
      unselectedItemColor: darkOnText.withValues(alpha: 0.5),
      type: BottomNavigationBarType.fixed,
      elevation: 12,
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: darkSurface),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: deepPurpleDark.withValues(alpha: 0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: glowPurple.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: accentMustard, width: 2),
      ),
      hintStyle: TextStyle(color: darkOnText.withValues(alpha: 0.5)),
    ),
  );
}
