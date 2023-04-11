import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Myauth {
  TextEditingController emailController;
  TextEditingController passwordController;
  Widget destination;

  Myauth(
      {required this.emailController,
      required this.passwordController,
      required this.destination});
  late BuildContext context;
  Future signUp() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => destination));
  }
}
