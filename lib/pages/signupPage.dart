import 'package:academy/helper/helper_functions.dart';
import 'package:academy/pages/login_page.dart';
import 'package:academy/service/auth_service.dart';
import 'package:academy/widgets/show_snack_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class SignupPage extends StatefulWidget {
  static const String screenRoute = 'SignupPage';

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String userName = '';
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 138, 190),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: 275,
              width: double.infinity,
              child: Image.asset(
                'assets/images/scAcademy.png',
                width: 375,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              heightFactor: 590,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 233, 233, 233),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                height: 590.0,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Login Formular Block
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 33, left: 33, top: 10),
                            child: Text(
                              "Erstelle hier einen neuen Account.",
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Voller Name
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  userName = value;
                                  print(userName);
                                });
                              },
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'Bitte geben Sie einen Namen an.';
                                }
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 20, right: 20),
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
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 218, 62, 1)),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Color.fromARGB(50, 1, 138, 190),
                                ),
                                labelText: 'Name',
                                hintStyle: GoogleFonts.montserrat(fontSize: 14),
                                fillColor: Color.fromARGB(255, 241, 241, 241),
                                filled: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                  print(email);
                                });
                              },
                              validator: (value) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value!)
                                    ? null
                                    : 'Bitte gebe eine E-Mail an';
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 20, right: 20),
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
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 218, 62, 1)),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Color.fromARGB(50, 1, 138, 190),
                                ),
                                labelText: 'E-Mail',
                                hintStyle: GoogleFonts.montserrat(fontSize: 14),
                                fillColor: Color.fromARGB(255, 241, 241, 241),
                                filled: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          //Password Textfield
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: TextFormField(
                              obscureText: true,
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                  print(email);
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 20, right: 20),
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
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 218, 62, 1)),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Color.fromARGB(50, 1, 138, 190),
                                ),
                                labelText: 'Password',
                                hintStyle: GoogleFonts.montserrat(fontSize: 14),
                                fillColor: Color.fromARGB(255, 241, 241, 241),
                                filled: true,
                              ),
                              validator: (value) {
                                if (value!.length < 6) {
                                  return 'Das Passwort muss mindestens 6 Zeichen haben.';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 25),

                          // sign in button
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              padding: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Material(
                                color: Color.fromARGB(255, 1, 138, 190),
                                shape: StadiumBorder(),
                                child: MaterialButton(
                                  onPressed: () {
                                    signup();
                                  },
                                  padding: EdgeInsets.only(left: 40, right: 40),
                                  child: Text(
                                    'Sign up',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Text.rich(
                              TextSpan(
                                style: GoogleFonts.montserrat(
                                    fontSize: 18, color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Account vorhanden? ',
                                  ),
                                  TextSpan(
                                      text: 'Jetzt einloggen.',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage()),
                                            ))
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Text.rich(
                              TextSpan(
                                style: GoogleFonts.montserrat(
                                    fontSize: 18, color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Datenschutz',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = (() {})),
                                  TextSpan(
                                    text: ' | ',
                                  ),
                                  TextSpan(
                                      text: 'AGB',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = (() {}))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  signup() async {
    setState(() {
      _isLoading = true;
    });
    await authService
        .registerUserWithEmailandPassword(userName, email, password)
        .then((value) async {
      if (value == true) {
        await HelperFunktions.saveUserLoggedInStatus(true);
        await HelperFunktions.saveUserEmailSF(email);
        await HelperFunktions.saveUserNameSF(userName);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        showSnackBar(context, Color.fromARGB(255, 218, 62, 1), value);
        setState(() {
          _isLoading = false;
        });
      }
    });
  }
}
