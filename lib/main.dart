import 'package:flutter/material.dart';
import 'package:movie_application/models/movie.dart';
import 'package:movie_application/screens/login_screen.dart';
import 'package:movie_application/screens/register_screen.dart';
import 'package:movie_application/screens/main_screen.dart';
import 'package:movie_application/screens/detail_screen.dart';
import 'package:movie_application/screens/home_screen.dart';
import 'package:movie_application/screens/list_movie_screen.dart';
import 'package:movie_application/screens/watchlist_screen.dart';
import 'package:movie_application/screens/splash_screen.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MainApp(
    isLoggedIn: isLoggedIn,
  ));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;
  const MainApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movie App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 42, 41, 52),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      home: SplashScreen(
        isLoggedIn: isLoggedIn,
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/main': (context) => const MainScreen(),
        '/detail-movie': (context) {
          final movie = ModalRoute.of(context)!.settings.arguments as Movie;
          return DetailScreen(movie: movie);
        },
        '/list-movie': (context) => const ListMovieScreen(),
        '/watchlist-movie': (context) => const WatchlistScreen(),
      },
    );
  }
}
