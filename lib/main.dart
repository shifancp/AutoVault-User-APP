import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_user/features/home/screens/dashboard.dart';
import 'package:auto_vault_user/features/authentication/providers/google_signin_provider.dart';
import 'package:auto_vault_user/features/authentication/providers/mobile_auth_provider.dart';
import 'package:auto_vault_user/features/testdrive/provider/testdrive_provider.dart';
import 'package:auto_vault_user/features/wishlist/provider/wishlist_provider.dart';
import 'package:auto_vault_user/features/products/screens/categorywise_feed.dart';
import 'package:auto_vault_user/features/products/screens/feed_screen.dart';
import 'package:auto_vault_user/features/authentication/screens/forget_password.dart';
import 'package:auto_vault_user/features/home/screens/home.dart';
import 'package:auto_vault_user/features/authentication/screens/login_screen.dart';
import 'package:auto_vault_user/features/authentication/screens/auth_check.dart';
import 'package:auto_vault_user/features/authentication/screens/mobile_number_verification.dart';
import 'package:auto_vault_user/features/testdrive/screens/completed_testdrives.dart';
import 'package:auto_vault_user/features/products/screens/product_page.dart';
import 'package:auto_vault_user/features/authentication/screens/signup_screen.dart';
import 'package:auto_vault_user/features/splashscreen/screen/splashscreen.dart';
import 'package:auto_vault_user/features/testdrive/screens/testdrive_screen.dart';
import 'package:auto_vault_user/features/user/screens/user_details_entering_screen.dart';
import 'package:auto_vault_user/features/wishlist/screens/wishlist_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCCNJ45kzuTmAqEYP0IqHkPuiS_tgirzO4',
          appId: '1:124223291911:android:63b8a3104700e2012d20a2',
          messagingSenderId: '124223291911',
          projectId: 'project-x-443322'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GoogleSignInProvider>(
          create: (context) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MobileAuthProvider(),
        ),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(
          create: (context) => TestDriveProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: const SplashScreen(),
        routes: {
          AuthCheck.routeName: (ctx) => const AuthCheck(),
          Dashboard.routeName: (ctx) => const Dashboard(),
          HomeScreen.routename: (ctx) => const HomeScreen(),
          FeedScreen.routename: (ctx) => const FeedScreen(),
          ProductPage.routename: (ctx) => const ProductPage(),
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          SignUpScreen.routeName: (ctx) => const SignUpScreen(),
          MobileNumber.routename: (ctx) => const MobileNumber(),
          WishlistScreen.routeName: (ctx) => const WishlistScreen(),
          TestDriveScreen.routeName: (ctx) => const TestDriveScreen(),
          UserDetailsEnteringScreen.routeName: (ctx) =>
              const UserDetailsEnteringScreen(),
          ForgetPassword.routeName: (ctx) => ForgetPassword(),
          CategoryWiseFeed.routeName: (ctx) => const CategoryWiseFeed(),
          PreviousTestDrives.routeName: (ctx) => const PreviousTestDrives(),
        },
      ),
    );
  }
}
