import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Impor google_fonts

// Definisikan tema kustom
ThemeData customTheme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    textTheme: GoogleFonts.latoTextTheme(
      ThemeData.light().textTheme,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
    ),
  );
}