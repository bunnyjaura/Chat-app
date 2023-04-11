import 'package:chat_app/utils/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['openid']);

class SignInController extends GetxController {
  final State = SignInState();
  SignInController();
  final db = FirebaseFirestore.instance;
  Future<void> handleSignIn() async {
    try {
      var user = await _googleSignIn.signIn();
      if (user != null) {
        String displayName = user.displayName ?? user.email;
        String email = user.email;
        String id = user.id;
        String photoUrl = user.photoUrl ?? '';
        // UserLoginResponseEntity userProfile = UserLoginResponseEntity();
        // userProfile.email = email;
        // userProfile.accessToken = id;
        // userProfile.displayName = displayName;
        // userProfile.photoUrl = photoUrl;
      }
    } catch (e) {}
  }
}

class SignInState {
  var index = 0.abs();
}
