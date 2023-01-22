import 'package:academy/helper/helper_functions.dart';
import 'package:academy/pages/chat_page.dart';
import 'package:academy/pages/home_chat_page.dart';
import 'package:academy/service/database_service.dart';
import 'package:academy/widgets/bottom_nav_bar.dart';
import 'package:academy/widgets/group_title.dart';
import 'package:academy/widgets/navigation_drawer.dart';
import 'package:academy/widgets/on_pressed.dart';
import 'package:academy/widgets/show_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  static const routeName = 'SearchPage';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = '';
  User? user;
  bool isJoined = false;

  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName() async {
    await HelperFunktions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getName(String r) {
    return r.substring(r.indexOf('_') + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 1, 138, 190),
        title: Text(
          'Suche',
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
          //Weißer Block
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: GoogleFonts.montserrat(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20, right: 20),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(50, 1, 138, 190)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 1, 138, 190)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelText: 'Suche',
                        hintStyle: GoogleFonts.montserrat(fontSize: 14),
                        fillColor: Color.fromARGB(255, 241, 241, 241),
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      initiateSearchMethod();
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 1, 138, 190),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(Icons.search, color: Colors.white),
                    ),
                  )
                ]),
              ),
              isLoading
                  ? Container(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 1, 138, 190),
                      ),
                    )
                  : groupList(),
            ],
          ),
        ),
      ),
    );
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService()
          .searchByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                userName,
                searchSnapshot!.docs[index]['groupId'],
                searchSnapshot!.docs[index]['groupName'],
                searchSnapshot!.docs[index]['admin'],
              );
            },
          )
        : Container();
  }

  joinedOrNot(
      String userName, String groupId, String groupName, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupName, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    // function to check wether user already exists in group
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Color.fromARGB(255, 1, 138, 190),
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
      ),
      title: Text(
        groupName,
        style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('Admin: ${getName(admin)}'),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid)
              .toggleGroupJoin(groupName, groupId, userName);
          if (isJoined) {
            setState(() {
              isJoined = isJoined;
            });
            showSnackBar(
                context, Colors.green, 'Der Gruppe erfolgreich beigetreten');
            Future.delayed(const Duration(seconds: 2), () {
              nextScreen(
                  context,
                  ChatPage(
                      userName: userName,
                      groupId: groupId,
                      groupName: groupName));
            });
          } else {
            setState(() {
              isJoined = !isJoined;
              showSnackBar(context, Colors.red,
                  'Die Gruppe $groupName erfolgreich verlassen');
            });
          }
        },
        child: isJoined
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Joined',
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 1, 138, 190),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Text(
                  'Join',
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
              ),
      ),
    );
  }
}
