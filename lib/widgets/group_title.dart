import 'package:academy/pages/chat_page.dart';
import 'package:academy/widgets/on_pressed.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile(
      {Key? key,
      required this.userName,
      required this.groupId,
      required this.groupName})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        nextScreen(
          context,
          ChatPage(
            userName: widget.userName,
            groupId: widget.groupId,
            groupName: widget.groupName,
          ),
        );
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Color.fromARGB(255, 1, 138, 190),
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
          title: Text(
            widget.groupName,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
          subtitle: Text(
            '${widget.userName} chatte mit uns',
            style: GoogleFonts.montserrat(
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
