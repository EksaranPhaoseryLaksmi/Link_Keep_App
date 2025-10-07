import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Wait 3 seconds then go to login screen
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent, // ✅ background stays green
      body: Stack(
        children: [
          // Optional: larger, centered logo as background
          Positioned.fill(
            child: Opacity(
              opacity: 0.2, // subtle background logo
              child: Image.asset(
                'assets/images/Keep-Logo.png',
                fit: BoxFit.cover, // cover whole screen
              ),
            ),
          ),
          // Foreground content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Main Logo
                Image.asset(
                  'assets/images/Keep-Logo.png',
                  width: 180, // larger logo
                  height: 180,
                ),
                const SizedBox(height: 24),

                // App Name
                Text(
                  'Link Keep Application',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Subtitle (Optional)
                Text(
                  'Save and manage your favorite links easily',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
