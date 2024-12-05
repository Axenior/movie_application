import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_application/models/movie.dart';
import 'package:movie_application/screens/login_screen.dart';
import 'package:movie_application/screens/main_screen.dart';
import 'package:movie_application/screens/detail_screen.dart';
import 'package:movie_application/screens/home_screen.dart';
import 'package:movie_application/screens/list_movie_screen.dart';
import 'package:movie_application/screens/profile_screen.dart';
import 'package:movie_application/screens/watchlist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MainApp(
    isLoggedIn: isLoggedIn,
  ));
}
// void main() {
//   runApp(
//     MainApp(),
//   );
// }

class MainApp extends StatelessWidget {
  final bool isLoggedIn;
  const MainApp({super.key, required this.isLoggedIn});
  // MainApp({super.key});

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
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
      routes: {
        '/login' : (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/main': (context) => const MainScreen(),
        '/detail-movie': (context) {
          final movie = ModalRoute.of(context)!.settings.arguments as Movie;
          return DetailScreen(movie: movie);
        },
        '/list-movie': (context) => const ListMovieScreen(),
        '/watchlist-movie': (context) => const WatchlistScreen(),
        // '/profile': (context) => const ProfileScreen(),
      },
      // home: const MainScreen(),
      // home: DetailScreen(movie: movieList[0]),
    );
  }
}
