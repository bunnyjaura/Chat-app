import 'dart:math';

import 'package:chat_app/components/squaretile.dart';
import 'package:chat_app/pages/Register_Page.dart';
import 'package:chat_app/pages/forgotPassPage.dart';
import 'package:chat_app/pages/phonePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/mytextfield.dart';
import '../components/my_button.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailcontroller = TextEditingController();

  final passwordcontroller = TextEditingController();

  void signUserIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text.trim(), password: passwordcontroller.text);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleuser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print(userCredential.user?.displayName);
      print('success');

      if (userCredential.user != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePage()));
      }
    } catch (e) {
      print('failed with: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color.fromARGB(255, 230, 230, 230),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            //Empty Space
            SizedBox(
              height: 115,
            ),

            //Login Text
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                  ),
                ),
              ],
            ),

            //Empty Space
            SizedBox(
              height: 20,
            ), //Email Textfield
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(10, -4),
                          blurRadius: 3,
                          color: Color.fromARGB(100, 0, 0, 0))
                    ],
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            'Welcome Back,',
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
                            'Sign in to continue',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    MyTextField(
                      controller: emailcontroller,
                      hintText: 'Email',
                      obscureText: false,
                    ),

                    //empty Space
                    const SizedBox(
                      height: 10,
                    ),

                    //Password Textfield
                    MyTextField(
                      controller: passwordcontroller,
                      hintText: 'Password',
                      obscureText: false,
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    //Forgot Password
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassPage()));
                            }),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),

                    //Sign in button
                    MyButton(
                      onTap: signUserIn,
                      buttonName: 'Sign in',
                    ),
                    const SizedBox(
                      height: 50,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Divider(
                              thickness: .5,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'or continue with',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 12),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: .5,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SquareTile(
                          logo: 'assets/images/google.png',
                          ontap: signInWithGoogle,
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        SquareTile(
                            ontap: () => setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PhonePage()));
                                }),
                            logo: 'assets/images/phone.png'),
                      ],
                    ),

                    const SizedBox(
                      height: 50,
                    ),

                    //Register Now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Not a member?'),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()));
                          }),
                          child: Text(
                            'Register now',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
