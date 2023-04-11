import 'package:chat_app/components/squaretile.dart';
import 'package:chat_app/pages/Register_Page.dart';
import 'package:chat_app/pages/forgotPassPage.dart';
import 'package:chat_app/pages/phonePage.dart';
import 'package:chat_app/screens/HomePage.dart';
import 'package:chat_app/screens/screenA.dart';
import 'package:chat_app/utils/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/mytextfield.dart';
import '../components/my_button.dart';
import 'auth.dart';
import 'home_page.dart';
import 'newPhonePage.dart';

class LoginRegister extends StatefulWidget {
  LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  final emailcontroller = TextEditingController();

  final passwordcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  bool isLogin = true;

  void signUserIn() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailcontroller.text.trim(),
            password: passwordcontroller.text);
    User? currentUser = user.user;
    if (user.additionalUserInfo!.isNewUser) {
      UserData().addUser(
          email: emailcontroller.text.trim(),
          name: currentUser!.displayName,
          id: currentUser.uid,
          photoUrl: currentUser.photoURL);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScreenA(
                  // photoUrl: currentUser!.photoURL,
                  userName: currentUser!.displayName,
                  uid: currentUser.uid,
                )));
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
      User? currentUser = userCredential.user;

      if (userCredential.additionalUserInfo!.isNewUser) {
        UserData().addUser(
            email: currentUser!.email,
            name: currentUser.displayName,
            id: currentUser.uid,
            photoUrl: currentUser.photoURL);
      }
      if (userCredential.user != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ScreenA(
                  userName: googleuser!.displayName,
                  uid: googleuser.id,
                  photoUrl: googleuser.photoUrl,
                )));
      }
    } catch (e) {
      print('failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
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
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    isLogin ? 'Login' : 'Register',
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
                      children: [
                        Visibility(
                          visible: isLogin ? true : false,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              'Welcome Back,',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: isLogin ? true : false,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              'Sign in to continue',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                        visible: isLogin ? false : true,
                        child: SizedBox(
                          height: 29,
                        )),
                    SizedBox(
                      height: 30,
                    ),

                    //Password Textfield
                    Visibility(
                      visible: isLogin ? false : true,
                      child: MyTextField(
                        controller: namecontroller,
                        hintText: 'Name',
                        obscureText: false,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                            child: Visibility(
                              visible: isLogin ? true : false,
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.black54),
                              ),
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
                      onTap: () {
                        if (isLogin == true) {
                          signUserIn();
                        } else {
                          signUp();
                        }
                      },
                      buttonName: isLogin ? 'Sign in' : 'Register',
                    ),
                    const SizedBox(
                      height: 30,
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
                      height: 30,
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
                                              const NewPhonePage()));
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
                        Text(isLogin ? 'Not a member?' : 'Already a member?'),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (isLogin == true) {
                              setState(() {
                                isLogin = false;
                              });
                            } else {
                              setState(() {
                                isLogin = true;
                              });
                            }
                          },
                          child: Text(
                            isLogin ? 'Register now' : 'Sign in',
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

  Future signUp() async {
    UserCredential _User = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailcontroller.text.trim(),
            password: passwordcontroller.text.trim());
    User? registeredUser = _User.user;

    UserData().addUser(
        email: emailcontroller.text.trim(),
        name: namecontroller.text,
        id: registeredUser!.uid);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ScreenA(
                  userName: namecontroller.text,
                  uid: registeredUser.uid,
                )));
  }
}
