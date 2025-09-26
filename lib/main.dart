import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme_notifier.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/meals_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const TitanStrongApp(),
    ),
  );
}

class TitanStrongApp extends StatelessWidget {
  const TitanStrongApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    // Colores principales
    const primaryYellow = Color(0xFFFFB300);
    const backgroundDark = Color(0xFF000000); // negro total
    const backgroundLight = Colors.white;

    InputDecorationTheme buildInputDecorationTheme({required bool isDark}) {
      return InputDecorationTheme(
        filled: true,
        fillColor: isDark ? Colors.grey[850] : const Color(0xFFF0F0F0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryYellow, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        labelStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
        hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
        prefixIconColor: isDark ? Colors.white : Colors.black,
      );
    }

    final lightTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryYellow,
        foregroundColor: Colors.black,
        elevation: 0,
        titleTextStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: primaryYellow, brightness: Brightness.light),
      textTheme: GoogleFonts.montserratTextTheme().apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
      inputDecorationTheme: buildInputDecorationTheme(isDark: false),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryYellow,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundDark,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: primaryYellow, brightness: Brightness.dark),
      textTheme: GoogleFonts.montserratTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      inputDecorationTheme: buildInputDecorationTheme(isDark: true),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryYellow,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Titan Strong',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeNotifier.themeMode,
      home: const SplashScreen(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegistrationScreen(),
        '/meals': (_) => const MealsScreen(),
      },
    );
  }
}
