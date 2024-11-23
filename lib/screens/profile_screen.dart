import 'package:flutter/material.dart';
import 'package:movie_application/components/BottomNavigationBarComponent.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: BottomNavigationBarComponent(),
    );
  }
}
