import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel_reservation/common/widgets/bottom_nav_bar.dart';
import 'package:hotel_reservation/screens/landing_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if (snapshot.hasData) {
            return const BottomNavBar();
          }
          //user is not logged in
          else {
            return const LandingScreen();
          }
        },
      ),
    );
  }
}
