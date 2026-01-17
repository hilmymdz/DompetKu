import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Status bar transparan dengan icon gelap
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DompetKu',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB), 
          brightness: Brightness.light,
          primary: const Color(0xFF2563EB),
          surface: const Color(0xFFF8FAFC), 
          surfaceContainer: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9), 
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20, 
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}