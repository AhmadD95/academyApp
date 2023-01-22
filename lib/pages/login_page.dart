import 'package:academy/helper/helper_functions.dart';
import 'package:academy/pages/signupPage.dart';
import 'package:academy/service/auth_service.dart';
import 'package:academy/service/database_service.dart';
import 'package:academy/widgets/on_pressed.dart';
import 'package:academy/widgets/show_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  static const String screenRoute = 'loginPage';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  late String email = '';
  late String password = '';
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 138, 190),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.white,
            ))
          : Stack(
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

                              Text(
                                'Willkommen',
                                style: GoogleFonts.montserrat(
                                  fontSize: 48,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 33, left: 33, top: 10),
                                child: Text(
                                  "Loge dich hier mit den Zugangsdaten, die du von Speed.Codes erhalten hast.",
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.clip,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30),

                              //Benutzername Textfield
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
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
                                          color:
                                              Color.fromARGB(50, 1, 138, 190)),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 1, 138, 190)),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 218, 62, 1)),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: Color.fromARGB(50, 1, 138, 190),
                                    ),
                                    labelText: 'E-Mail',
                                    hintStyle:
                                        GoogleFonts.montserrat(fontSize: 14),
                                    fillColor:
                                        Color.fromARGB(255, 241, 241, 241),
                                    filled: true,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              //Password Textfield
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
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
                                          color:
                                              Color.fromARGB(50, 1, 138, 190)),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 1, 138, 190)),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 218, 62, 1)),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Color.fromARGB(50, 1, 138, 190),
                                    ),
                                    labelText: 'Password',
                                    hintStyle:
                                        GoogleFonts.montserrat(fontSize: 14),
                                    fillColor:
                                        Color.fromARGB(255, 241, 241, 241),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
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
                                        login();
                                      },
                                      padding:
                                          EdgeInsets.only(left: 40, right: 40),
                                      child: Text(
                                        'Sign in',
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
                              Container(
                                child: TextButton(
                                  onPressed: () {
                                    nextScreen(context, SignupPage());
                                  },
                                  child: Text(
                                    'Jetzt registrieren',
                                    style: GoogleFonts.montserrat(
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
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
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving the values to our shared orefernces
          await HelperFunktions.saveUserLoggedInStatus(true);
          await HelperFunktions.saveUserEmailSF(email);

          nextScreenReplace(context, const HomePage());
        } else {
          showSnackBar(context, Color.fromARGB(255, 218, 62, 1), value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
