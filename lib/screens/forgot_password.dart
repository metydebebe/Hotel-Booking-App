import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_reservation/common/widgets/my_button.dart';
import 'package:hotel_reservation/common/styles/pallete.dart';
import 'package:hotel_reservation/common/widgets/my_text_field.dart';
import 'package:quickalert/quickalert.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Pallete.gradient2,
          ),
        );
      },
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      Navigator.of(context).pop();
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success',
        text: 'Password Reset link sent. Check your email.',
        confirmBtnText: 'OK',
      );
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: e.message.toString(),
        confirmBtnText: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            /** const Text(
              'Forgot Password?',
              style: TextStyle(
                  color: Pallete.blackColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ), */
            const SizedBox(height: 20),
            Text(
              'Enter your email and we will send you a password reset link.',
              textAlign: TextAlign.center,
              style: Pallete.textStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 30),
            MyTextField(
                controller: _emailController,
                hintText: 'Email',
                obscureText: false),
            const SizedBox(height: 30),
            MyButton(onTap: () => passwordReset(), text: 'Submit')
          ],
        ),
      ),
    );
  }
}
