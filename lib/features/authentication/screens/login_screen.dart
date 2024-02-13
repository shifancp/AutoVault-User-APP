import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:auto_vault_user/features/home/screens/dashboard.dart';
import 'package:auto_vault_user/features/authentication/providers/google_signin_provider.dart';
import 'package:auto_vault_user/features/authentication/screens/forget_password.dart';
import 'package:auto_vault_user/features/authentication/screens/mobile_number_verification.dart';
import 'package:auto_vault_user/features/authentication/screens/signup_screen.dart';
import 'package:auto_vault_user/services/utils.dart';
import 'package:auto_vault_user/widgets/custom_text_widget.dart';
import 'package:auto_vault_user/widgets/textformfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/login.png',
                    height: 100,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const CustomTextWidget(
                          text: 'LogIn',
                          color: Colors.deepPurple,
                          textSize: 50,
                          isTitle: true,
                        ),
                        CustomTextField(
                          focusNode: emailFocusNode,
                          hintText: 'Enter Email Address',
                          controllername: _emailController,
                          prefixIconData: CupertinoIcons.mail,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          obscureText: _isObscured,
                          focusNode: passwordFocusNode,
                          hintText: 'Enter Password',
                          controllername: _passwordController,
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
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(ForgetPassword.routeName);
                      },
                      child: const Text('Forgot Password'),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _logIn();
                    },
                    icon: const Icon(Icons.login_outlined),
                    label: const Text('LogIn'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(SignUpScreen.routeName);
                    },
                    child: const Text(
                      'Create an account',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  const Text('Or Continue With'),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          provider.googleLogin(context);
                        },
                        child: Material(
                          color: Colors.transparent,
                          elevation: 10,
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            child: Image.asset(
                              'assets/images/google.png',
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(MobileNumber.routename);
                        },
                        child: Material(
                          color: Colors.transparent,
                          elevation: 10,
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            child: Image.asset(
                              'assets/images/phone.png',
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(Dashboard.routeName);
                    },
                    child: const Text(
                      'Continue as guest',
                      style: TextStyle(
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Login Function
  void _logIn() async {
    try {
      _emailController.clear();
      _passwordController.clear();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Dashboard.routeName, (route) => false);
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
  }
}
