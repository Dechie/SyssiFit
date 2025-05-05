import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';
import 'package:sissifit/screens/home.dart';
import 'package:sissifit/screens/login_page.dart'; // Assuming your login/register pages are here

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top Image
            // Ensure you have an image at this path or replace with a placeholder
            ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/logos/sissiphys2.jpg', // <-- Verify this path
                width: 150,
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if image fails to load
                  return Container(
                    width: 150,
                    height: 150,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            // Bottom Text with Fade Animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                //'One Must Image Sissiphys Happy, and FIT!',
                "Smartly Track Your Fitness",
                textAlign: TextAlign.center, // Center the text
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(color: colorScheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Animation duration
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Start the fade-in animation
    _controller.forward();

    // Wait for the splash screen duration, then check auth state and navigate
    Timer(const Duration(seconds: 3), () {
      // Check if a user is currently signed in
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // No user is signed in, navigate to the Login Page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ), // <-- Navigate to LoginPage
        );
      } else {
        // User is signed in, navigate to the Home Page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ), // <-- Navigate to HomePage
        );
      }
    });
  }
}
