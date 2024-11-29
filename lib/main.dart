import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_application/controllers/movie_controller.dart';
import 'package:movie_application/controllers/navigation_controller.dart';
import 'package:movie_application/screens/detail_screen.dart';
import 'package:movie_application/screens/home_screen.dart';
import 'package:movie_application/screens/list_movie_screen.dart';
import 'package:movie_application/screens/profile_screen.dart';
import 'package:movie_application/screens/watchlist_screen.dart';

void main() {
  runApp(
    MainApp(),
  );
}

final routes = [
  GetPage(
    name: "/",
    page: () => const HomeScreen(),
  ),
  GetPage(
    name: "/detail-movie",
    page: () => DetailScreen(movie: Get.arguments),
  ),
  GetPage(
    name: "/list-movie",
    page: () => const ListMovieScreen(),
  ),
  GetPage(
    name: "/watchlist",
    page: () => const WatchlistScreen(),
  ),
  GetPage(
    name: "/profile",
    page: () => const ProfileScreen(),
  ),
];

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final MovieController mc = Get.put(MovieController());
  final NavigationController rc = Get.put(NavigationController());
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
      getPages: routes,
      home: const HomeScreen(),
      // home: DetailScreen(movie: movieList[0]),
    );
  }
}
