import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const double cardBorderRadius = 50.0;

  // Define the primary theme of the app
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.dosis(fontSize: 16.0, color: Colors.black),
      bodyMedium: GoogleFonts.dosis(fontSize: 14.0, color: Colors.grey[700]),
      bodySmall: GoogleFonts.dosis(fontSize: 12.0, color: Colors.grey[700]),
      titleLarge: GoogleFonts.dosis(),
      displayLarge:
          GoogleFonts.dosis(fontSize: 24.0, fontWeight: FontWeight.bold),
      displayMedium:
          GoogleFonts.dosis(fontSize: 20.0, fontWeight: FontWeight.bold),
      displaySmall:
          GoogleFonts.dosis(fontSize: 16.0, fontWeight: FontWeight.bold),
      headlineLarge:
          GoogleFonts.dosis(fontSize: 70.0, fontWeight: FontWeight.bold),
      headlineMedium:
          GoogleFonts.dosis(fontSize: 50.0, fontWeight: FontWeight.bold),
      headlineSmall:
          GoogleFonts.dosis(fontSize: 30.0, fontWeight: FontWeight.bold),
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    tabBarTheme: TabBarTheme(
      labelStyle: GoogleFonts.dosis(
        fontSize: 14.0,
      ),
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      unselectedLabelStyle: GoogleFonts.dosis(fontSize: 14.0),
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        side: const BorderSide(color: Colors.black, width: 2.0),
      ),
      elevation: 0,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: Colors.black,
      labelStyle: GoogleFonts.dosis(
        fontSize: 14.0,
        color: Colors.black,
      ),
      secondaryLabelStyle: GoogleFonts.dosis(
        fontSize: 14.0,
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      shape: const StadiumBorder(
        side: BorderSide(color: Colors.black),
      ),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        textStyle: WidgetStateProperty.all<TextStyle>(
          GoogleFonts.dosis(
            fontSize: 14.0,
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: GoogleFonts.dosis(
        fontSize: 14.0,
        color: Colors.black,
      ),
      hintStyle: GoogleFonts.dosis(
        fontSize: 14.0,
        color: Colors.grey[600],
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide:
            BorderSide(color: Colors.grey), // Grey line for enabled state
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
            color: Colors.black, width: 1.5), // Black line for focus state
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
            color: Colors.red, width: 1.5), // Red line for error state
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
            color: Colors.red, width: 1.5), // Red line for focused error state
      ),
      isDense: true, // Reduce padding for the text field
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0), // Adjust padding
    ),
  );
}
