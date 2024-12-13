import 'package:flutter/material.dart';
import 'package:movie_application/screens/login_screen.dart';
import 'package:movie_application/screens/main_screen.dart';

class SplashScreen extends StatelessWidget {
  final bool isLoggedIn;

  const SplashScreen({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isLoggedIn ? const MainScreen() : const LoginScreen(),
        ),
      );
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/cinemate_logo.jpeg', // Path gambar splash
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 16),
            const Text(
              'CineMate',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
