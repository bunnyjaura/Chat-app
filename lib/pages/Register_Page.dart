import 'package:chat_app/pages/phonePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/my_button.dart';
import '../components/mytextfield.dart';
import '../components/squaretile.dart';
import 'home_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

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

  Future signUp() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
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
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            //Empty Space
            const SizedBox(
              height: 80,
            ),

            //Login Text
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'Register.',
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
                    'Welcome,',
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
                    'Sign up to continue',
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
              height: 40,
            ),
            //Email Textfield
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),

            //empty Space
            const SizedBox(
              height: 10,
            ),

            //Password Textfield
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),

            const SizedBox(
              height: 5,
            ),

            //Forgot Password

            const SizedBox(
              height: 25,
            ),

            //Sign in button
            MyButton(
              onTap: signUp,
              buttonName: 'Sign up',
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
                  logo: 'assets/images/google.png',
                  ontap: signInWithGoogle,
                ),
                const SizedBox(
                  width: 50,
                ),
                SquareTile(
                    ontap: () => setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PhonePage()));
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
                const Text('Already a member?'),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }),
                  child: const Text(
                    'Sign in',
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
}
