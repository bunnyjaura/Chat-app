import 'package:chat_app/StyleColors.dart';
import 'package:chat_app/pages/auth_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatelessWidget {
  String? userName;
  var photoUrl;
  ProfilePage({super.key, required this.userName, this.photoUrl});

  var users = FirebaseFirestore.instance.collection('Users').doc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 198, 198, 198),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await GoogleSignIn().signOut();
              FirebaseAuth.instance.signOut();

              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AuthPage()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: CircleAvatar(
                radius: 54,
                backgroundColor: Styles().colorBack,
                child: CircleAvatar(
                  radius: 52,
                  backgroundColor: Styles().colorBack,
                  child: CircleAvatar(
                    foregroundImage: NetworkImage(photoUrl ??
                        'https://images.unsplash.com/photo-1517849845537-4d257902454a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=435&q=80'),
                    radius: 49,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              userName!,
              style: Styles().HeadingText,
            ),
          ),
        ],
      ),
    );
  }
}
