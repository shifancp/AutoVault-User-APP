import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:auto_vault_user/features/home/screens/dashboard.dart';
import 'package:auto_vault_user/features/authentication/providers/mobile_auth_provider.dart';
import 'package:auto_vault_user/features/user/screens/user_details_entering_screen.dart';
import 'package:auto_vault_user/services/utils.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.verificationId});
  final String verificationId;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

String? otpCode;

class _OtpScreenState extends State<OtpScreen> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // Get the loading state from the MobileAuthProvider
    final isLoading =
        Provider.of<MobileAuthProvider>(context, listen: true).isLoading;

    // Get the screen size using utility function
    final Size size = Utils(context).getScreenSize;

    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/verification.png',
                      height: size.height * 0.1,
                    ),
                    const Text(
                      'Enter OTP below',
                      style: TextStyle(fontSize: 20, color: Colors.deepPurple),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    OTPTextField(
                      length: 6,
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 50,
                      style: const TextStyle(fontSize: 17),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.box,
                      onCompleted: (pin) {
                        setState(() {
                          otpCode = pin;
                        });
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: size.height * 0.05,
                      child: ElevatedButton(
                        onPressed: () {
                          if (otpCode != null) {
                            verifyOtp(context, otpCode!);
                          } else {
                            Fluttertoast.showToast(msg: 'Enter 6-Digit Code');
                          }
                        },
                        child: const Text(
                          'Verify',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // Function to verify OTP
  void verifyOtp(BuildContext context, String userOtp) {
    final provider = Provider.of<MobileAuthProvider>(context, listen: false);
    provider.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userOtp,
      onSuccess: () {
        // Checking whether the user exists in the database
        provider.checkExistingUser().then((value) async {
          if (value == true) {
            Navigator.pushNamedAndRemoveUntil(
                context, Dashboard.routeName, (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, UserDetailsEnteringScreen.routeName, (route) => false);
          }
        });
      },
    );
  }
}
