import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/student_form_screen.dart';
import 'package:project4_remidi/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://selxjncjapcgegdriabr.supabase.co',
    anonKey: 'YOUR_ANON_KEY',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project4 Remidi',
      theme: customTheme(),
      home: const SplashScreen(),

      // ✅ Lokalization untuk DatePicker
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('id'),
      ],

      // ✅ Route
      routes: {
        '/home': (context) => const HomeScreen(),
        '/form': (context) => const StudentFormScreen(),
      },
    );
  }
}
