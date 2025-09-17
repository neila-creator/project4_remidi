import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Impor untuk GoogleFonts
import 'theme.dart'; // Impor theme.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: customTheme(), // Gunakan tema kustom dari theme.dart
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Project 4 Remidi'),
        ),
        body: const Center(
          child: Text(
            'Formula Data Siswa', // Teks ini untuk tes
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}