import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_application/screens/home_screen.dart';

void main() {
  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Movie App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            color: Color.fromARGB(255, 42, 41, 52),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            color: Color.fromARGB(255, 42, 41, 52),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
          labelSmall: TextStyle(
            color: Color.fromARGB(255, 11, 3, 50),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          bodySmall: TextStyle(
            color: Color.fromARGB(255, 11, 3, 50),
            fontSize: 12,
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 62, 58, 78),
          secondary: Color.fromARGB(255, 97, 96, 96),
          onPrimary: Color.fromARGB(255, 18, 93, 178),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
