import 'dart:ui';

import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../StyleColors.dart';
import '../utils/user.dart';

class ContactsList extends StatefulWidget {
  String fromId;
  final String? currentUserId;
  ContactsList({super.key, this.currentUserId, required this.fromId});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  var users = FirebaseFirestore.instance.collection('Users');

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                titlePadding:
                    const EdgeInsets.only(right: 0, left: 10, top: 35),
                expandedTitleScale: 1.3,
                title: Text('Contacts',
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
        body: Container(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(10, -1),
                      blurRadius: 10,
                      color: Color.fromARGB(100, 0, 0, 0))
                ],
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(35))),
            child: StreamBuilder<QuerySnapshot>(
              stream: users.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Text('snapshot error ${snapshot.error}');
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      photoUrl: ds['photoUrl'],
                                      targetid: ds['id'],
                                      userName: ds['name'],
                                      sentbyMe: true,
                                      fromId: widget.fromId,
                                    )));
                      },
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) => BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 70),
                                    child: AlertDialog(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 20),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      content: SizedBox(
                                        height: 90,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {},
                                              child: const Center(
                                                child: Text(
                                                  'Edit',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                            ),
                                            const Divider(),
                                            GestureDetector(
                                              onTap: () {
                                                UserData().dltUser(
                                                    index: snapshot
                                                        .data!.docs[index].id);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Center(
                                                child: Text(
                                                  'Delete',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          foregroundImage: NetworkImage(ds['photoUrl'] ??
                              'https://images.unsplash.com/photo-1517849845537-4d257902454a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=435&q=80'),
                          radius: 25,
                        ),
                        title: Text(ds['name']),
                        subtitle: Text(ds['email']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   materialTapTargetSize: MaterialTapTargetSize.padded,
      //   onPressed: () {
      //     showDialog(
      //         context: context,
      //         builder: (context) => BackdropFilter(
      //               filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      //               child: AlertDialog(
      //                 shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(18)),
      //                 title: const Text('Add Contact'),
      //                 actionsAlignment: MainAxisAlignment.center,
      //                 content: SizedBox(
      //                   height: 200,
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                     children: [
      //                       TextFormField(
      //                         controller: nameController,
      //                         keyboardType: TextInputType.name,
      //                         decoration: InputDecoration(
      //                           fillColor: Colors.white,
      //                           filled: true,
      //                           hintText: 'Name',
      //                           enabledBorder: OutlineInputBorder(
      //                               borderRadius: BorderRadius.circular(8),
      //                               borderSide:
      //                                   const BorderSide(color: Colors.grey)),
      //                           focusedBorder: OutlineInputBorder(
      //                               borderRadius: BorderRadius.circular(8),
      //                               borderSide:
      //                                   const BorderSide(color: Colors.grey)),
      //                         ),
      //                       ),
      //                       TextFormField(
      //                         controller: emailController,
      //                         keyboardType: TextInputType.emailAddress,
      //                         decoration: InputDecoration(
      //                           fillColor: Colors.white,
      //                           filled: true,
      //                           hintText: 'Email',
      //                           enabledBorder: OutlineInputBorder(
      //                               borderRadius: BorderRadius.circular(8),
      //                               borderSide:
      //                                   const BorderSide(color: Colors.grey)),
      //                           focusedBorder: OutlineInputBorder(
      //                               borderRadius: BorderRadius.circular(8),
      //                               borderSide:
      //                                   const BorderSide(color: Colors.grey)),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 actionsPadding: const EdgeInsets.only(bottom: 30),
      //                 actions: [
      //                   SizedBox(
      //                     height: 40,
      //                     width: 100,
      //                     child: ElevatedButton(
      //                         onPressed: () {
      //                           UserData().addUser(
      //                               email: emailController.text.trim(),
      //                               name: nameController.text.trim());
      //                           Navigator.of(context).pop();
      //                           nameController.clear();
      //                           emailController.clear();
      //                         },
      //                         child: const Text('Ok')),
      //                   ),
      //                   SizedBox(
      //                     height: 40,
      //                     width: 100,
      //                     child: ElevatedButton(
      //                         onPressed: () {
      //                           Navigator.of(context).pop();
      //                           nameController.clear();
      //                           emailController.clear();
      //                         },
      //                         child: const Text('Cancel')),
      //                   ),
      //                 ],
      //               ),
      //             ));
      //   },
      //   backgroundColor: Styles().colorTheme,
      //   child: const Icon(Icons.add),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
