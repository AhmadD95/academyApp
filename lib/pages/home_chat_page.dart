import 'dart:ui';

import 'package:academy/helper/helper_functions.dart';
import 'package:academy/pages/chat_page.dart';
import 'package:academy/pages/search_page.dart';
import 'package:academy/service/auth_service.dart';
import 'package:academy/service/database_service.dart';
import 'package:academy/widgets/bottom_nav_bar.dart';
import 'package:academy/widgets/group_title.dart';
import 'package:academy/widgets/navigation_drawer.dart';
import 'package:academy/widgets/on_pressed.dart';
import 'package:academy/widgets/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeChatPage extends StatefulWidget {
  const HomeChatPage({Key? key}) : super(key: key);

  static const routeName = 'HomeChatPage';

  @override
  State<HomeChatPage> createState() => _HomeChatPageState();
}

class _HomeChatPageState extends State<HomeChatPage> {
  String userName = '';
  String email = '';
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunktions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunktions.getUserNameFromSF().then((valu) {
      setState(() {
        userName = valu!;
      });
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, SearchPage());
              },
              icon: const Icon(Icons.search))
        ],
        shape: RoundedRectangleBorder(),
        backgroundColor: Color.fromARGB(255, 1, 138, 190),
        elevation: 0,
      ),
      bottomNavigationBar: ButtomNavBar(index: 1),
      extendBodyBehindAppBar: false,
      drawer: NavigationDrawerNav(),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 1, 138, 190),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 249, 249, 249),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: groupList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        child: Icon(Icons.group_add),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: Text(
                'Gruppe erstellen',
                style: GoogleFonts.montserrat(),
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 1, 138, 190),
                          ),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(50, 1, 138, 190)),
                                  borderRadius: BorderRadius.circular(30)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 1, 138, 190)),
                                  borderRadius: BorderRadius.circular(30)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 218, 62, 1)),
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 1, 138, 190)),
                  child: Text(
                    'Abbrechen',
                    style: GoogleFonts.montserrat(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(userName,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackBar(
                          context, Colors.green, 'Gruppe wurde erstellt.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 1, 138, 190)),
                  child: Text(
                    'Erstellen',
                    style: GoogleFonts.montserrat(),
                  ),
                ),
              ],
            );
          }));
        });
  }

  groupList() {
    return StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'] != 0) {
                return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (centext, index) {
                    int reverseIndex =
                        snapshot.data['groups'].length - index - 1;
                    return GroupTile(
                      userName: snapshot.data['userName'],
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                    );
                  },
                );
              } else {
                return noGroupWidget();
              }
            } else {
              return noGroupWidget();
            }
          } else {
            return const Center(
                child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 1, 138, 190)));
          }
        });
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (() {
              popUpDialog(context);
            }),
            child: Icon(
              Icons.group_add,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Du bist in keiner Gruppe oder hast einen Chat begonnen, klicke auf das Hinzufügen Symbol oder suche oben nach einer Gruppe.',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(fontSize: 14),
          )
        ],
      ),
    );
  }
}
