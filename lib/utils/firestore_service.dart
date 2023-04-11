// import 'dart:async';

// import 'package:chat_app/utils/user.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';
//   String? targetid;
// class FirestoreService {

//   final CollectionReference userCollectionRef =
//       FirebaseFirestore.instance.collection('Users');

//   final CollectionReference msgCollectionRef = FirebaseFirestore.instance
//                   .collection('messages')
//                   .doc(targetid )
//                   .collection('chats')    ;

//   final StreamController<List<Message>> _chatController =
//       StreamController<List<Message>>.broadcast();
//   Future createUser(UserModel user) async {
//     try {
//       userCollectionRef.doc(user.id).set(user.toJson());
//     } catch (e) {
//       if (e is PlatformException) {
//         return e.message;
//       }
//       e.toString();
//     }
//   }

//   Stream listenToMessagesInRealtime(String friendId, String CurrentUserId) {
//     _requestMessage(friendId, CurrentUserId);
//     // return _msgController.stream;
//   }

//   void _requestMessage(String friendId, String ccurrentUserId){
//     var messageQuerySnapshot = 
//   }
// }
