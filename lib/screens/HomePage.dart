import 'package:animations/animations.dart';
import 'package:chat_app/StyleColors.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/profile.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/utils/functions.dart';
import 'package:chat_app/utils/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/chatroom_model.dart';

class HomePage1 extends StatefulWidget {
  final UserModel? userModel;
  String fromId;
  final String? currentUserId;
  HomePage1(
      {super.key, required this.fromId, this.userModel, this.currentUserId});

  @override
  State<HomePage1> createState() => _HomePage1State();
}

var users = FirebaseFirestore.instance.collection('Users');
// Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
//   await FirebaseFirestore.instance.collection('messages').where('participants');
// }
final chatListQuery = FirebaseFirestore.instance.collection('messages');

Future<String?> getUserPhoto(String userId) async {
  DocumentReference userRef =
      FirebaseFirestore.instance.collection('Users').doc(userId);
  DocumentSnapshot snapshot = await userRef.get(GetOptions(
    source: Source.server,
  ));

  dynamic myFieldValue = snapshot.get('photoUrl');
  print(myFieldValue);
}

class _HomePage1State extends State<HomePage1> {
  String searchKey = '';
  Stream? streamQuery;
  late Stream<QuerySnapshot> _userStream;
  late Stream<QuerySnapshot> chatListquery;

  void initState() {
    super.initState();
    _userStream = FirebaseFirestore.instance
        .collection('Users')
        .where('id', isNotEqualTo: widget.fromId)
        .snapshots();
    chatListquery =
        FirebaseFirestore.instance.collection('messages').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(right: 0, left: 10, top: 35),
                  expandedTitleScale: 1.3,
                  title: Text('Chats',
                      style: GoogleFonts.poppins(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                ),
                expandedHeight: 130,
                pinned: true,
                backgroundColor: Colors.grey[50],
                floating: true,
              ),
            ];
          },
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: 15),
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(10, -1),
                            blurRadius: 10,
                            color: Color.fromARGB(100, 0, 0, 0))
                      ],
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(35))),
                  child: ListView(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: (searchKey != '')
                            ? users
                                .where("name",
                                    isGreaterThanOrEqualTo: searchKey)
                                .where('name', isLessThan: searchKey + 'z')
                                .snapshots()
                            : chatListquery,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text('Empty');
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: snapshot.data!.docs.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data!.docs[index];

                              final chatId = snapshot.data!.docs[index].id;
                              return StreamBuilder<Map<String, dynamic>>(
                                stream: UserData()
                                    .getLastMessageAndTime(chatId)
                                    .asStream(),
                                builder: (context, snapshot) {
                                  final lastMessage =
                                      snapshot.data!.containsKey('lastMessage')
                                          ? snapshot.data!['lastMessage']
                                          : null;
                                  final lastMessageTime = snapshot.data!
                                          .containsKey('lastMessageTime')
                                      ? snapshot.data!['lastMessageTime']
                                      : null;
                                  // String photoUrl =
                                  //     getUserEmail(widget.fromId) as String;
                                  return OpenContainer(
                                      closedElevation: 0,
                                      openElevation: 0,
                                      middleColor: Colors.white,
                                      closedColor: Colors.transparent,
                                      transitionDuration:
                                          Duration(milliseconds: 400),
                                      transitionType:
                                          ContainerTransitionType.fadeThrough,
                                      openBuilder: (BuildContext,
                                          VoidCallback openContainer) {
                                        return ChatScreen(
                                          // photoUrl: ds['photoUrl'],
                                          fromId: widget.fromId,
                                          sentbyMe: true,
                                          userName: ds['name'],
                                          targetid: ds['toId'],
                                        );
                                      },
                                      closedBuilder: (BuildContext,
                                          VoidCallback openContainer) {
                                        return GestureDetector(
                                          onTap: openContainer,
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              foregroundImage: NetworkImage(ds[
                                                      'photoUrl'] ??
                                                  'https://images.unsplash.com/photo-1517849845537-4d257902454a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=435&q=80'),
                                              radius: 25,
                                            ),
                                            title: Text(
                                              ds['name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17,
                                                fontFamily: 'araboto_bold',
                                              ),
                                            ),
                                            subtitle: Text(
                                              lastMessage,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  fontFamily: 'araboto_thin'),
                                            ),
                                            trailing: Text(
                                              lastMessageTime,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color.fromARGB(
                                                      172, 66, 66, 66),
                                                  fontFamily: 'araboto_light'),
                                            ),
                                          ),
                                        );
                                      });
                                },
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   child: TextField(
              //     onChanged: (value) {
              //       setState(() {
              //         searchKey = value;
              //       });
              //     },
              //     decoration: InputDecoration(
              //       filled: true,
              //       fillColor: Colors.white,
              //       prefixIcon: Icon(Icons.search),
              //       hintText: 'Search',
              //       enabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(30),
              //           borderSide: BorderSide(color: Styles().colorTheme)),
              //       focusedBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(30),
              //           borderSide: BorderSide(color: Styles().colorTheme)),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
