// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:chat_app/utils/user.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../StyleColors.dart';
import '../utils/chatroom_model.dart';

class ChatScreen extends StatefulWidget {
  String fromId;
  String targetid;
  String userName;
  final ChatRoomModel? chatroom;
  bool? sentbyMe;

  var photoUrl;
  ChatScreen({
    super.key,
    required this.userName,
    this.fromId = '',
    this.chatroom,
    this.sentbyMe,
    this.targetid = '',
    this.photoUrl,
  });

  Stream<List<MessageModel>> getCombinedStream(
      String currentUserId, String otherUserId) {
    // Combine the two streams of received and sent messages into a single stream
    final Stream<List<MessageModel>> receivedStream = FirebaseFirestore.instance
        .collection('messages')
        .doc(currentUserId)
        .collection('chats')
        .where('fromId', isEqualTo: otherUserId)
        .where('toId', isEqualTo: currentUserId)
        .orderBy('time')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList()
            .cast<MessageModel>());
    final Stream<List<MessageModel>> sentStream = FirebaseFirestore.instance
        .collection('messages')
        .doc(otherUserId)
        .collection('chats')
        .where('fromId', isEqualTo: currentUserId)
        .where('toId', isEqualTo: otherUserId)
        .orderBy('time')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList()
            .cast<MessageModel>());
    return Rx.combineLatest2<List<MessageModel>, List<MessageModel>,
            List<MessageModel>>(
        receivedStream, sentStream, (received, sent) => received + sent);
  }

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

TextEditingController msgController = TextEditingController();
FirebaseAuth auth = FirebaseAuth.instance;

class _ChatScreenState extends State<ChatScreen> {
  var items;
  late Stream<List<MessageModel>> _messageStream;

  @override
  void initState() {
    super.initState();
    _messageStream =
        widget.getCombinedStream(auth.currentUser!.uid, widget.targetid);
  }

  // here you write the codes to input the data into firestore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: 65,
          elevation: 0,
          leadingWidth: 55,
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () => setState(() {
                          Navigator.pop(context);
                        }),
                    child: CircleAvatar(
                        backgroundColor: Styles().colorBack,
                        foregroundColor: Colors.white,
                        radius: 22,
                        child: const FaIcon(FontAwesomeIcons.arrowLeft))),
              ],
            ),
          ),
          title: Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                gradient: Styles().themeGradient,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundImage: NetworkImage(widget.photoUrl ??
                          'https://images.unsplash.com/photo-1517849845537-4d257902454a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=435&q=80')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.userName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            StreamBuilder<List<MessageModel>>(
              stream: _messageStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<MessageModel>> snapshot) {
                if (!snapshot.hasData) {
                  return Text('snapshot error ${snapshot.error}');
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    MessageModel message = snapshot.data![index];
                    bool isSent = message.fromId == auth.currentUser!.uid;

                    return BubbleSpecialTwo(
                      isSender: isSent,
                      color: isSent ? Styles().colorTheme : Colors.blueGrey,
                      text: message.message,
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                      tail: false,
                    );
                  },
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                color: Colors.grey[50],
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: TextField(
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Message',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:
                                      BorderSide(color: Styles().colorTheme)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:
                                      BorderSide(color: Styles().colorTheme)),
                            ),
                            controller: msgController,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (msgController.text == '') {
                            print('TextField is  empty');
                          } else {
                            print('TextField is not empty');
                            setState(() {
                              UserData().sendMsg(
                                  fromId: auth.currentUser!.uid,
                                  toId: widget.targetid,
                                  message: msgController.text,
                                  name: widget.userName);
                              UserData().lastMessage(
                                  lastMsg: msgController.text,
                                  docId: widget.targetid,
                                  name: widget.userName,
                                  photoUrl: widget.photoUrl);
                            });
                            msgController.clear();
                            print('CurrentUser id is ${auth.currentUser} ');
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Styles().colorTheme,
                          foregroundColor: Colors.white,
                          radius: 22,
                          child: const Icon(Icons.send),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
