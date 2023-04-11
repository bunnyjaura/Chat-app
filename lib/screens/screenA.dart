// ignore_for_file: file_names

import 'package:animations/animations.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../StyleColors.dart';

import 'HomePage.dart';
import 'chat_screen.dart';
// ignore: unused_import
import 'contactsList.dart';
import 'screenB.dart';
import 'settings.dart';

class ScreenA extends StatefulWidget {
  var uid;
  String? userName;
  String? photoUrl;
  ScreenA({super.key, this.uid, this.userName, this.photoUrl});

  @override
  State<ScreenA> createState() => _ScreenAState();
}

class _ScreenAState extends State<ScreenA> {
  getUserName(String docid) async {
    DocumentReference documentReference = users.doc(docid);
    String? userName;
    await documentReference.get().then((snapshot) {
      userName = snapshot.data.toString();
    });
    return userName;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 20, right: 5),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 10, color: Styles().colorTheme.withOpacity(.35))
              ],
              borderRadius: BorderRadius.circular(80),
            ),
            child: OpenContainer(
              closedElevation: 0,
              openElevation: 0,
              closedColor: Colors.transparent,
              middleColor: Colors.white,
              transitionDuration: const Duration(milliseconds: 400),
              closedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80)),
              transitionType: ContainerTransitionType.fadeThrough,
              closedBuilder: (BuildContext, VoidCallback openContainer) {
                return GestureDetector(
                  onTap: openContainer,
                  child: CircleAvatar(
                    radius: 34,
                    backgroundColor: Styles().colorBack,
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(widget.photoUrl ??
                            'https://images.unsplash.com/photo-1517849845537-4d257902454a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=435&q=80'),
                      ),
                    ),
                  ),
                );
              },
              openBuilder: (BuildContext, VoidCallback openContainer) {
                return ProfilePage(
                  userName: widget.userName,
                  photoUrl: widget.photoUrl,
                );
              },
            ),
          ),
        ),

        body: Stack(
          children: [
            TabBarView(children: [
              HomePage1(
                fromId: widget.uid,
              ),
              ContactsList(
                fromId: widget.uid,
              )
            ]),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TabBar(
                    overlayColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                    indicatorWeight: 5,
                    indicatorColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: [
                      Container(
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Styles().colorBack,
                            borderRadius: BorderRadius.circular(30)),
                        child: const Center(
                          child: Tab(
                            icon: FaIcon(FontAwesomeIcons.home),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Styles().colorBack,
                            borderRadius: BorderRadius.circular(30)),
                        child: const Center(
                          child: Tab(
                            icon: FaIcon(FontAwesomeIcons.contactBook),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        ),
        // bottomNavigationBar:
      ),
    );
  }
}
