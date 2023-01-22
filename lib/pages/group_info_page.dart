import 'package:academy/pages/home_chat_page.dart';
import 'package:academy/service/database_service.dart';
import 'package:academy/widgets/on_pressed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupInfo extends StatefulWidget {
  final String adminName;
  final String groupId;
  final String groupName;
  const GroupInfo(
      {Key? key,
      required this.adminName,
      required this.groupId,
      required this.groupName})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
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
          'Gruppen Info',
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Verlassen'),
                      content: const Text(
                          'Bist du dir sicher, dass du die Gruppe verlassen möchtest?'),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            DatabaseService(
                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                .toggleGroupJoin(widget.groupName,
                                    widget.groupId, getName(widget.adminName))
                                .whenComplete(() {
                              nextScreen(context, const HomeChatPage());
                            });
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 24,
                bottom: 24,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 57,
                    backgroundColor: Color.fromARGB(255, 1, 138, 190),
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          fontSize: 50,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.groupName}',
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: GoogleFonts.montserrat(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Admin: ${getName(widget.adminName)}',
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: GoogleFonts.montserrat(fontSize: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.black54),
                  const SizedBox(height: 24),
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      'Mitglieder',
                      style: GoogleFonts.montserrat(fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: ((context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['members'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Color.fromARGB(255, 1, 138, 190),
                          child: Text(
                            getName(
                              snapshot.data['members'][index]
                                  .substring(0, 1)
                                  .toUpperCase(),
                            ),
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ),
                        title: Text(getName(snapshot.data['members'][index])),
                        subtitle: Text(getId(snapshot.data['members'][index])),
                      ),
                    );
                  });
            } else {
              return Center(
                  child: Text('keine Mitglieder',
                      style: GoogleFonts.montserrat()));
            }
          } else {
            return Center(
                child:
                    Text('keine Mitglieder', style: GoogleFonts.montserrat()));
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 1, 138, 190),
            ),
          );
        }
      }),
    );
  }
}
