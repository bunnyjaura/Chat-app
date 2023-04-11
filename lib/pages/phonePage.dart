import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/my_button.dart';
import '../components/mytextfield.dart';
import '../components/squaretile.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Register_Page.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  TextEditingController phonecontroller = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool otpVisibility = false;
  User? user;
  String verificationID = '';

  signInWithGoogle() async {
    GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleuser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);

    if (userCredential.user != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
    }
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
            const SizedBox(
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
            const SizedBox(
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
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  controller: phonecontroller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey)),
                      hintText: 'Phone No.',
                      prefixStyle: const TextStyle(color: Colors.black),
                      prefix: const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Text(
                          '+91',
                        ),
                      ),
                      hintStyle: TextStyle(color: Colors.grey.shade400))),
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              onTap: loginWithPhone,
              buttonName: 'Send OTP',
            ),

            const SizedBox(
              height: 89,
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
                      style: TextStyle(color: Colors.black54, fontSize: 12),
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
                    ontap: signInWithGoogle, logo: 'assets/images/google.png'),
                const SizedBox(
                  width: 50,
                ),
                SquareTile(
                    ontap: () => setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        }),
                    logo: 'assets/images/email.png'),
              ],
            ),
            const SizedBox(
              height: 50,
            ),

            //Register Now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Not a member?'),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()));
                  }),
                  child: const Text(
                    'Register now',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
        phoneNumber: '+91' + phonecontroller.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) {
            print('Logged in successfully');
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          verificationID = verificationId;
          print('OTP sent');
          setState(() {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const OtpPage()));
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }
}
