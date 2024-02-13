import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_user/features/home/screens/dashboard.dart';
import 'package:auto_vault_user/features/authentication/screens/login_screen.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({Key? key}) : super(key: key);

  static const routeName = '/authcheck';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Listen to changes in the authentication state
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the connection is still waiting, show a loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // If the user is authenticated, navigate to the Dashboard
        else if (snapshot.hasData) {
          return const Dashboard();
        }
        // If there is an error, display an error message
        else if (snapshot.hasError) {
          return const Center(
            child: Text('Something Went Wrong'),
          );
        }
        // If the user is not authenticated, navigate to the LoginScreen
        else {
          return const LoginScreen();
        }
      },
    );
  }
}
