import 'package:flutter/material.dart';
import 'package:iot/utils/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final initialRoute = user != null ? AppRoutes.home : AppRoutes.login;

    return MaterialApp(
      title: 'IOT App',
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF171923),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C63FF),
          secondary: Color(0xFF2D2F36),
          surface: Color(0xFF22223C),
        ),
        appBarTheme: AppBarTheme(
          color: const Color(0xFF23242B),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white70),
          titleTextStyle: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF6C63FF),
          foregroundColor: Colors.white,
        ),
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 18,
            color: Colors.white70,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.white60,
          ),
          titleMedium: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C63FF),
            disabledBackgroundColor: const Color(0xFF373A47),
            shadowColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF6C63FF),
            textStyle: GoogleFonts.inter(),
          ),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xFF212235),
        ),
        dividerTheme: const DividerThemeData(
          color: Colors.white12,
          space: 1,
          thickness: 1,
        ),
      ),
    );
  }
}
