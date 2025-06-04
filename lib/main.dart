import 'package:flutter/material.dart';
import 'package:movie_application/screens/login_screen.dart';
import 'package:movie_application/screens/profile_screen.dart';
import 'package:movie_application/screens/register_screen.dart';
import 'package:movie_application/screens/main_screen.dart';
import 'package:movie_application/screens/detail_screen.dart';
import 'package:movie_application/screens/home_screen.dart';
import 'package:movie_application/screens/watchlist_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:movie_application/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://cngwhjhwbavcliddwgko.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNuZ3doamh3YmF2Y2xpZGR3Z2tvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg3NzYwOTgsImV4cCI6MjA2NDM1MjA5OH0.puhcPYHHg2vnyG312Uu8ypycJJnGfgQk4VGIWsHD1Xc', // Ganti dengan anon public key Anda
    debug: true,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(ThemeMode.light),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    // Muat preferensi tema saat aplikasi dimulai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ThemeNotifier>(context, listen: false).loadTheme();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: "Movie App",
      debugShowCheckedModeBanner: false,
      themeMode: themeNotifier.themeMode,

      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          foregroundColor: Color.fromARGB(255, 42, 41, 52),
          titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 42, 41, 52),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black),
        ),
      ),

      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 30, 30, 30),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18),
        cardColor: const Color.fromARGB(255, 38, 38, 38),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: user != null ? const MainScreen() : const LoginScreen(),
      // Definisi route
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/main': (context) => const MainScreen(),
        '/detail-movie': (context) {
          final movieId = ModalRoute.of(context)!.settings.arguments as int;
          return DetailScreen(
            movieId: movieId,
          );
        },
        '/watchlist-movie': (context) => const WatchlistScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
