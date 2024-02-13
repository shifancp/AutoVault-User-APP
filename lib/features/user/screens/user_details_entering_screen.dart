import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:auto_vault_user/features/home/screens/dashboard.dart';
import 'package:auto_vault_user/features/authentication/providers/mobile_auth_provider.dart';
import 'package:auto_vault_user/services/utils.dart';
import 'package:auto_vault_user/widgets/custom_text_widget.dart';
import 'package:auto_vault_user/widgets/textformfield_widget.dart';
import 'package:provider/provider.dart';

class UserDetailsEnteringScreen extends StatefulWidget {
  const UserDetailsEnteringScreen({super.key});
  static const routeName = '/detailsenteringpage';
  @override
  State<UserDetailsEnteringScreen> createState() =>
      _UserDetailsEnteringScreenState();
}

class _UserDetailsEnteringScreenState extends State<UserDetailsEnteringScreen> {
  // Firebase authentication instance
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;

  // GlobalKey for the form
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // Focus nodes for text fields
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  // Flag to control password visibility
  bool _isObscured = false;

  @override
  void initState() {
    super.initState();
    // Set initial state for password visibility
    _isObscured = true;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = Utils(context).getScreenSize;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Custom title widget
              const CustomTextWidget(
                text: 'Enter the details',
                color: Colors.black,
                textSize: 50,
                isTitle: true,
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Text field for user name
                    CustomTextField(
                      hintText: 'Enter Your Name',
                      controllername: _nameController,
                      prefixIconData: CupertinoIcons.person,
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    // Text field for email
                    CustomTextField(
                      focusNode: emailFocusNode,
                      hintText: 'Enter Email Address',
                      controllername: _emailController,
                      prefixIconData: CupertinoIcons.mail,
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Enter Valid Email'
                              : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    // Text field for password
                    CustomTextField(
                      obscureText: _isObscured,
                      focusNode: passwordFocusNode,
                      hintText: 'Enter Password',
                      controllername: _passwordController,
                      validator: (value) => value != null && value.length < 6
                          ? 'Enter min 6 Characters'
                          : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      prefixIconData: CupertinoIcons.lock,
                      // Toggle password visibility
                      suffixIconData: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                        icon: _isObscured
                            ? const Icon(CupertinoIcons.eye)
                            : const Icon(CupertinoIcons.eye_slash),
                      ),
                    ),
                  ],
                ),
              ),
              // Button to proceed with user details
              ElevatedButton.icon(
                onPressed: () {
                  saveDetails();
                },
                icon: const Icon(Icons.create),
                label: const Text('Proceed'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to save user details
  void saveDetails() async {
    // Access the mobile authentication provider
    final provider = Provider.of<MobileAuthProvider>(context, listen: false);
    String uid = provider.uid;
    String mobileNumber = provider.mobileNumber;
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) return;
    try {
      // Save user details to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'userName': name,
        'userId': uid,
        'userEmail': email,
        'userPhone': mobileNumber,
      });
      if (!context.mounted) return;
      // Navigate to the dashboard
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Dashboard.routeName, (route) => false);
      // Clear text controllers
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    } catch (e) {
      // Handle errors and display a toast message
      Fluttertoast.showToast(msg: '$e');
    }
  }
}
