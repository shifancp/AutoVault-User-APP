import 'package:flutter/material.dart';
import 'package:auto_vault_user/features/authentication/screens/auth_check.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start the navigation process when the screen is initialized
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(image: AssetImage('assets/images/splash.gif')),
      ),
    );
  }

  // Navigate to the AuthCheck screen after a delay
  Future<void> navigate() async {
    // Delay for 4 seconds to display the splash screen
    await Future.delayed(const Duration(seconds: 4));

    // Check if the context is still valid before navigating
    if (!context.mounted) return;

    // Navigate to the AuthCheck screen and remove the splash screen from the navigation stack
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AuthCheck.routeName, (route) => false);
  }
}
