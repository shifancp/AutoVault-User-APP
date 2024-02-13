import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_user/features/home/screens/dashboard.dart';
import 'package:auto_vault_user/features/authentication/screens/login_screen.dart';
import 'package:auto_vault_user/services/utils.dart';
import 'package:auto_vault_user/widgets/custom_text_widget.dart';
import 'package:auto_vault_user/widgets/textformfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String routeName = '/signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.routeName, (route) => false);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
                const CustomTextWidget(
                  text: 'Sign Up',
                  color: Colors.deepPurple,
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
                      CustomTextField(
                        hintText: 'Enter Your Name',
                        controllername: _nameController,
                        prefixIconData: CupertinoIcons.person,
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
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
                      CustomTextField(
                        maxLength: 10,
                        hintText: 'Enter Your Mobile Number',
                        controllername: _mobileNumberController,
                        prefixIconData: CupertinoIcons.phone,
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
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
                ElevatedButton.icon(
                  onPressed: () {
                    _signUp();
                  },
                  icon: const Icon(Icons.create),
                  label: const Text('Create an Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // SignUp function
  void _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final mobileNumber = _mobileNumberController.text.trim();
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) return;

    try {
      firebase_auth.UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'userName': name,
        'userId': userCredential.user!.uid,
        'userEmail': email,
        'userPhone': mobileNumber,
      });

      if (!context.mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Dashboard.routeName, (route) => false);

      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
  }
}
