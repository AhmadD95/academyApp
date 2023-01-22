import 'package:academy/pages/home_chat_page.dart';
import 'package:academy/pages/home_page.dart';
import 'package:academy/pages/kalender.dart';
import 'package:academy/widgets/on_pressed.dart';
import 'package:flutter/material.dart';

class ButtomNavBar extends StatelessWidget {
  ButtomNavBar({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Color.fromARGB(255, 1, 138, 190),
      unselectedItemColor: Colors.black.withAlpha(100),
      items: [
        BottomNavigationBarItem(
          icon: Container(
            margin: const EdgeInsets.only(left: 50),
            child: IconButton(
              onPressed: () {
                nextScreen(context, HomePage());
              },
              icon: const Icon(
                Icons.home,
              ),
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              nextScreen(context, HomeChatPage());
            },
            icon: const Icon(
              Icons.question_answer_outlined,
            ),
          ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(right: 50),
              child: IconButton(
                onPressed: () {
                  nextScreen(context, CalenderWidget());
                },
                icon: const Icon(
                  Icons.calendar_month,
                ),
              ),
            ),
            label: 'Kalender'),
      ],
    );
  }
}
