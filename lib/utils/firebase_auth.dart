import 'package:chat_app/utils/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/screenA.dart';
import 'firestore_service.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late UserModel _currentUser;
  UserModel get currentUser => _currentUser;

  Future signUp(String email, String password, String name) async {
    var authResult = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    _currentUser =
        UserModel(email: email, name: name, id: authResult.user!.uid);
    return authResult.user != null;
  }
}
