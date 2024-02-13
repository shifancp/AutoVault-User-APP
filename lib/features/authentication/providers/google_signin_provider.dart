import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// A provider class for handling Google Sign-In functionality.
class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  /// Getter for the currently signed-in user.
  GoogleSignInAccount get user => _user!;

  /// Initiates the Google Sign-In process.
  Future googleLogin(BuildContext context) async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      firebase_auth.UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Store user details in Firestore upon successful login
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'userName': userCredential.user!.displayName,
        'userEmail': userCredential.user!.email,
        'userPhone': userCredential.user!.phoneNumber,
      });
    } catch (e) {
      // Handle any exceptions and display a toast message
      Fluttertoast.showToast(msg: '$e');
    }
    notifyListeners();
  }

  /// Signs out the user from both Firebase and Google Sign-In.
  Future logOut() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    notifyListeners();
  }
}
