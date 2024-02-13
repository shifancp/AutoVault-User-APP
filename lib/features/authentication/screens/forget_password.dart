import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_user/widgets/textformfield_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({Key? key}) : super(key: key);

  static const routeName = '/forgetPassword';

  // Controller for the email text field
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Custom text field for entering email
              CustomTextField(
                hintText: 'Enter Your Email',
                controllername: _emailController,
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Get the email from the text field and initiate password reset
                    String email = _emailController.text;
                    resetPassword(email);
                    // Close the forget password screen
                    Navigator.of(context).pop();
                  },
                  child: const Text('Reset Password'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Function to initiate the password reset process
  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      // Handle and display any errors that may occur during the reset process
      Fluttertoast.showToast(msg: '$e');
    }
  }
}
