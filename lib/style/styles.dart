import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  // Цвета
  static const Color primaryColor = Color(0xFF6DA0E1);
  static const Color accentColor = Color(0xFF85ABDB);
  static const Color backgroundColor = Color(0xFFF0F4FA);
  static const Color buttonTextColor = Colors.white;
  static const Color secondaryAccent = Color(0xFFDEC1DB);
  static const Color routhAccent = Color(0xFF5b61b2);

  // Текстовые стили
  static TextStyle logo = GoogleFonts.agdasima(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static TextStyle timerText = GoogleFonts.dongle(
    fontSize: 55,
    fontWeight: FontWeight.bold,
    color: const Color(0xDDeee2df),
  );

  static TextStyle mainText = GoogleFonts.lobster(
    fontSize: 70,
    fontWeight: FontWeight.w500,
    color: secondaryAccent,
    shadows: [
      Shadow(
        offset: Offset(3, 3), // Смещение тени по X и Y
        blurRadius: 5, // Размытие
        color: const Color.fromARGB(50, 4, 4, 4), // Цвет тени
      ),
      Shadow(
          offset: Offset(-3, -3), // Смещение тени по X и Y
          blurRadius: 5, // Размытие
          color: const Color.fromARGB(50, 255, 255, 255) // Цвет тени
          ),
    ],
  );

  static TextStyle mixMain = GoogleFonts.lobster(
    fontSize: 30,
    fontWeight: FontWeight.w500,
    color: secondaryAccent,
    shadows: [
      Shadow(
        offset: Offset(1, 1),
        blurRadius: 3,
        color: const Color.fromARGB(50, 4, 4, 4),
      ),
      Shadow(
          offset: Offset(-1, -1),
          blurRadius: 3,
          color: const Color.fromARGB(50, 255, 255, 255)),
    ],
  );

  static TextStyle buttons = GoogleFonts.pragatiNarrow(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: const Color(0xDDeee2df),
  );

  static TextStyle popTitles = GoogleFonts.pragatiNarrow(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(255, 32, 32, 32),
      shadows: [
        BoxShadow(
          offset: Offset(1, 1),
          color: const Color.fromARGB(50, 255, 255, 255),
          blurRadius: 2,
        )
      ]);

  static final ButtonStyle smallButton = ElevatedButton.styleFrom(
    backgroundColor: accentColor,
    foregroundColor: buttonTextColor,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 2,
  );
}
