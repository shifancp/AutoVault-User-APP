import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:auto_vault_user/features/authentication/screens/otp_entering_screen.dart';

/// A provider class for handling mobile authentication.
class MobileAuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;
  String? _mobileNumber;
  String get mobileNumber => _mobileNumber!;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  /// Initiates the phone sign-in process.
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    _mobileNumber = phoneNumber;
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: ((verificationId) {}),
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
    notifyListeners();
  }

  /// Verifies the OTP entered by the user.
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOtp,
      );
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(creds);
      User? user = userCredential.user;
      if (user != null) {
        _uid = user.uid;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: '$e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Checks if the user already exists in the Firestore database.
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection('users').doc(_uid).get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }
}
