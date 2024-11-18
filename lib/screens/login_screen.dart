// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hotel_reservation/common/widgets/bottom_nav_bar.dart';
import 'package:hotel_reservation/common/widgets/my_button.dart';
import 'package:hotel_reservation/common/widgets/my_text_field.dart';
import 'package:hotel_reservation/common/styles/pallete.dart';
import 'package:hotel_reservation/screens/forgot_password.dart';
import 'package:hotel_reservation/data/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Pallete.gradient2,
            ),
          );
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: message,
      confirmBtnText: 'OK',
    );
  }

  bool _isSigningIn = false;

  void _handleSignIn() async {
    setState(() {
      _isSigningIn = true; // Show the loading indicator
    });

    try {
      await AuthService().signInWithGoogle();
      Get.to(() => const BottomNavBar());
    } catch (e) {
      // Handle any errors here
    } finally {
      setState(() {
        _isSigningIn = false; // Hide the loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/signin_balls.png'),
              const SizedBox(height: 25),
              const Text(
                'Sign In',
                style: TextStyle(
                    color: Pallete.blackColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () => Get.to(() => const ForgotPassword()),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                      color: Color.fromARGB(255, 63, 61, 61), fontSize: 16),
                ),
              ),
              const SizedBox(height: 25),
              MyButton(
                onTap: signUserIn,
                text: 'Log In',
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    const Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Pallete.greyColor,
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    const Expanded(
                        child:
                            Divider(thickness: 0.5, color: Pallete.greyColor))
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Stack(children: [
                GestureDetector(
                  onTap: _isSigningIn ? null : _handleSignIn,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 235, 235, 243),
                      border: Border.all(color: Pallete.gradient2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _isSigningIn
                        ? const CircularProgressIndicator(
                            color: Pallete.gradient2,
                          )
                        : Image.asset(
                            'assets/images/google_logo.png',
                            height: 50,
                          ),
                  ),
                ),
              ]),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account?',
                    style: TextStyle(fontSize: 16, color: Pallete.blackColor),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Register now.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Pallete.blackColor),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
