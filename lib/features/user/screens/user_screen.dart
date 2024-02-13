import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_user/features/authentication/providers/google_signin_provider.dart';
import 'package:auto_vault_user/features/authentication/screens/forget_password.dart';
import 'package:auto_vault_user/features/authentication/screens/login_screen.dart';
import 'package:auto_vault_user/features/testdrive/screens/completed_testdrives.dart';
import 'package:auto_vault_user/features/wishlist/screens/wishlist_screen.dart';
import 'package:auto_vault_user/services/utils.dart';
import 'package:auto_vault_user/widgets/icon_text_widgets.dart';
import 'package:auto_vault_user/widgets/custom_text_widget.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;

    // Initialize with an empty string
    final Size size = Utils(context).getScreenSize;

    return Scaffold(
      body: user == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomTextWidget(
                    text: 'Please Login for Details',
                    color: Colors.black,
                    textSize: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.05,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(LoginScreen.routeName);
                      },
                      child: const Text('Go to Login Page'),
                    ),
                  )
                ],
              ),
            )
          : FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.hasData && snapshot.data!.exists) {
                  // Extract user details
                  String displayName = snapshot.data!['userName'];
                  String userEmail = snapshot.data!['userEmail'];

                  return Column(
                    children: [
                      // Display user information
                      ListTile(
                        leading: const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            'assets/images/user-avatar.png',
                          ),
                        ),
                        title: Text(
                          'Hi $displayName',
                          style: const TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                          userEmail,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      // User actions
                      IconAndText(
                        text: 'My Previous Test Drives',
                        iconData: Icons.car_rental,
                        onTap: () {
                          Navigator.pushNamed(
                              context, PreviousTestDrives.routeName);
                        },
                      ),
                      IconAndText(
                        text: 'My Wishlist',
                        iconData: Icons.favorite_outline_outlined,
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(WishlistScreen.routeName);
                        },
                      ),
                      IconAndText(
                        text: 'Reset Password',
                        iconData: Icons.password_outlined,
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ForgetPassword.routeName);
                        },
                      ),
                      IconAndText(
                        text: 'Log Out',
                        iconData: Icons.logout,
                        onTap: () {
                          // Log out the user
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          provider.logOut();
                          // Navigate to the login screen
                          Navigator.of(context)
                              .pushReplacementNamed(LoginScreen.routeName);
                        },
                      ),
                    ],
                  );
                } else {
                  // Display login prompt if user details not available
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomTextWidget(
                          text: 'Please Login for Details',
                          color: Colors.black,
                          textSize: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: size.height * 0.05,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(LoginScreen.routeName);
                            },
                            child: const Text('Go to Login Page'),
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
    );
  }
}
