import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import 'login_page.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  TextEditingController emailController = TextEditingController();
  forgotPass() {
    FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 24, 205, 255),
          Color.fromARGB(87, 221, 68, 68)
        ], begin: Alignment.topRight, end: Alignment.centerLeft)),
        child: Center(
          child: Column(children: [
            SizedBox(
              height: 108,
            ),

            //Login Text
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'Recover.',
                    style: TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'You idiot,',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'Enter your e-mail',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),

            //Empty Space
            const SizedBox(
              height: 80,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey)),
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey.shade400))),
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              onTap: forgotPass,
              buttonName: 'Send',
            ),

            const SizedBox(
              height: 89,
            ),
          ]),
        ),
      ),
    );
  }
}
