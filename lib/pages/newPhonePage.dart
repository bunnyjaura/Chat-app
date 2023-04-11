import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/loginRegister.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/otp_page.dart';
import 'package:chat_app/screens/screenA.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/my_button.dart';
import '../components/mytextfield.dart';
import '../components/squaretile.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Register_Page.dart';

class NewPhonePage extends StatefulWidget {
  const NewPhonePage({super.key});

  @override
  State<NewPhonePage> createState() => _NewPhonePageState();
}

class _NewPhonePageState extends State<NewPhonePage> {
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController otpcontroller = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool otpVisibility = false;
  User? user;
  String _actualCode = '';

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
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            'Welcome',
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
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            'Enter phone to continue',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                        visible: otpVisibility ? false : true,
                        child: SizedBox(
                          height: 29,
                        )),
                    SizedBox(
                      height: 30,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          maxLength: otpVisibility ? 6 : 10,
                          controller:
                              otpVisibility ? otpcontroller : phonecontroller,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                              hintText: otpVisibility ? 'OTP' : 'Phone No.',
                              prefix: Visibility(
                                  visible: otpVisibility ? false : true,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Text('+91'),
                                  )),
                              prefixStyle: TextStyle(color: Colors.black),
                              hintStyle:
                                  TextStyle(color: Colors.grey.shade400))),
                    ),

                    //empty Space
                    const SizedBox(
                      height: 10,
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    //Sign in button
                    MyButton(
                      onTap: () {
                        otpVisibility
                            ? verifyOTP()
                            : verifyPhone('+91' + phonecontroller.text);
                      },
                      buttonName: otpVisibility ? 'Verify' : 'Send OTP',
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
                                              LoginRegister()));
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
                        Text(otpVisibility
                            ? 'Not a member?'
                            : 'Already a member?'),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          otpVisibility ? 'Register now' : 'Sign in',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
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

  Future<void> verifyPhone(String number) async {
    await auth.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) {
        Fluttertoast.showToast(msg: 'Completed');
      },
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(msg: 'Failed');
        print('Failed with: $e');
      },
      codeSent: (String verificationId, int? resendToken) {
        Fluttertoast.showToast(msg: 'Code Sent');
        _actualCode = verificationId;
        setState(() {
          otpVisibility = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        Fluttertoast.showToast(msg: 'Timeout');
      },
    );
  }

  Future<void> verifyOTP() async {
    try {
      UserCredential user = await auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: _actualCode, smsCode: otpcontroller.text));
      User? _currentUser = user.user;
      setState(() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => ScreenA(
                      uid: _currentUser!.uid,
                      userName: _currentUser.phoneNumber,
                    ))));
      });
    } catch (e) {
      print('Failed with $e');
    }
  }
}
