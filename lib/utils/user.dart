import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

FirebaseAuth auth = FirebaseAuth.instance;
Timestamp timestamp = Timestamp.now();

class UserData {
  Future<Map<String, dynamic>> getLastMessageAndTime(String id) async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('messages').doc(id).get();
    if (querySnapshot.exists) {
      return {
        'lastMessage': querySnapshot.data()!['lastMessage'],
        'lastMessageTime': querySnapshot.data()!['lastMessageTime']
      };
    }
    return {};
  }

  Future addUser(
      {required String? email,
      required String? name,
      String? id,
      String? photoUrl}) async {
    final users = FirebaseFirestore.instance.collection('Users').doc(id);
    final user =
        UserModel(email: email, name: name, id: id, photoUrl: photoUrl);
    final json = user.toJson();
    await users.set(json);
    return 'userid is ${users.id}';
  }

  Future dltUser({
    required String index,
  }) async {
    final users =
        FirebaseFirestore.instance.collection('Users').doc(index).delete();
  }

  Future sendMsg(
      {required String message,
      var name,
      required String toId,
      var fromId}) async {
    final messages = FirebaseFirestore.instance
        .collection('messages')
        .doc(toId)
        .collection('chats')
        .doc();
    final abc = MessageModel(
      fromId: fromId,
      time: DateTime.now().toLocal().millisecondsSinceEpoch,
      toId: toId,
      name: name,
      message: message,
    );
    final json = abc.toJson();
    await messages.set(json);
  }

  String formattedTime = DateFormat('hh:mm a').format(timestamp.toDate());

  Future lastMessage(
      {String? lastMsg, var docId, String? name, var photoUrl}) async {
    DocumentReference lastMessages =
        FirebaseFirestore.instance.collection('messages').doc(docId);
    final abcd = LastMessageModel(
        toId: docId,
        lastMessage: lastMsg,
        name: name,
        lastMessageTime: formattedTime,
        photoUrl: photoUrl);

    final json = abcd.toJson();
    await lastMessages.set(json);
  }
}

class UserModel {
  var id;
  var name;
  var email;
  var photoUrl;

  UserModel({
    this.id = '',
    required this.email,
    required this.name,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
      };

  static fromJson(Map<String, dynamic>? json) => UserModel(
        email: json?['email'],
        name: json?['name'],
        id: json?['id'],
        photoUrl: json?['photoUrl'],
      );
}

class MessageModel {
  var toId;
  String? fromId;
  String? name;

  var message;
  var time;

  MessageModel(
      {required this.toId, this.message, this.name, this.fromId, this.time});
  Map<String, dynamic> toJson() => {
        'toId': toId,
        'name': name,
        'message': message,
        'time': time,
        'fromId': fromId
      };

  static fromJson(Map<String, dynamic> json) => MessageModel(
      message: json['message'],
      name: json['name'],
      toId: json['toId'],
      time: json['time'],
      fromId: json['fromId']);
}

class LastMessageModel {
  var toId;
  var photoUrl;
  String? name;
  String? lastMessage;
  String lastMessageTime;

  LastMessageModel({
    required this.toId,
    this.name,
    this.lastMessage,
    this.photoUrl,
    required this.lastMessageTime,
  });
  Map<String, dynamic> toJson() => {
        'toId': toId,
        'name': name,
        'photoUrl': photoUrl,
        'lastMessage': lastMessage,
        'lastMessageTime': lastMessageTime,
      };

  static fromJson(Map<String, dynamic> json) => LastMessageModel(
        name: json['name'],
        toId: json['toId'],
        lastMessage: json['lastMessage'],
        photoUrl: json['photoUrl'],
        lastMessageTime: json['lastMessageTime'],
      );
}
