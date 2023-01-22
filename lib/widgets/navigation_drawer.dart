import 'package:academy/helper/helper_functions.dart';
import 'package:academy/pages/login_page.dart';
import 'package:academy/pages/profile_page.dart';
import 'package:academy/service/auth_service.dart';
import 'package:academy/widgets/on_pressed.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigationDrawerNav extends StatefulWidget {
  static const String screenRoute = 'loginPage';

  const NavigationDrawerNav({super.key});

  @override
  State<NavigationDrawerNav> createState() => _NavigationDrawerNavState();
}

class _NavigationDrawerNavState extends State<NavigationDrawerNav> {
  String userName = '';
  String email = '';
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunktions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunktions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Material(
        color: Color.fromARGB(255, 1, 138, 190),
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(
              top: 24 + MediaQuery.of(context).padding.top,
              bottom: 24,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundImage: AssetImage('assets/images/ahmadProfil.jpg'),
                ),
                SizedBox(height: 12),
                Text(
                  userName,
                  style:
                      GoogleFonts.montserrat(fontSize: 16, color: Colors.white),
                ),
                Text(
                  email,
                  style:
                      GoogleFonts.montserrat(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          runSpacing: 16,
          children: [
            ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: const Text('Profil'),
              onTap: () {
                nextScreen(context, ProfilePage());
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.notifications_outlined),
            //   title: const Text('Benachrichtigung'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: const Icon(Icons.brightness_6_outlined),
            //   title: const Text('Design'),
            //   onTap: () {},
            // ),
            const Divider(
              color: Colors.black54,
            ),
            ListTile(
              leading: const Icon(Icons.info_outlined),
              title: const Text('Über uns'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Abmelden'),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Ausloggen'),
                      content: const Text(
                          'Bist du dir sicher, dass du dich ausloggen möchtest?'),
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
                            await authService.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);
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
            ),
            ListTile(
              leading: null,
              title: Container(
                padding: EdgeInsets.only(
                  top: 24 + MediaQuery.of(context).padding.top,
                ),
                child: Column(
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/images/SpeedCodesLogoBlackFont.png',
                      ),
                    ),
                    Center(
                      child: Text(
                        'Speed.Codes',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Agency & Academy GmbH',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '© 2022 - All rights reserved',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
