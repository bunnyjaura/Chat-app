import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/squaretile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'login_page.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController otpcontroller = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool otpVisibility = false;
  User? user;
  String verificationID = "";
  String otpPin = "";
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
                    'Login.',
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

            //Empty Space
            const SizedBox(
              height: 80,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  controller: otpcontroller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey)),
                      hintText: 'OTP',
                      hintStyle: TextStyle(color: Colors.grey.shade400))),
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              onTap: verifyOTP,
              buttonName: 'Verify OTP',
            ),

            const SizedBox(
              height: 89,
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> verifyOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: otpcontroller.text);

      await auth.signInWithCredential(credential).then(
        (value) {
          setState(() {
            user = FirebaseAuth.instance.currentUser;
          });
        },
      ).whenComplete(
        () {
          if (user != null) {
            print('Success');
            Fluttertoast.showToast(
              msg: "You are logged in successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          } else {
            print('failed');
            Fluttertoast.showToast(
              msg: "your login is failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        },
      );
    } catch (e) {
      print('failed with: $e');
    }
  }
}
