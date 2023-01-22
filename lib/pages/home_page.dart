import 'package:academy/widgets/bottom_nav_bar.dart';
import 'package:academy/widgets/custom_tag.dart';
import 'package:academy/widgets/navigation_drawer.dart';
import 'package:academy/widgets/on_pressed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'article_screen.dart';

class HomePage extends StatefulWidget {
  static const String screenRoute = 'homePage';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: ButtomNavBar(index: 0),
      extendBodyBehindAppBar: true,
      drawer: NavigationDrawerNav(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: [
                // Titel
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("articles")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                            scrollDirection: Axis.vertical,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            itemCount: 1,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var data = snapshot.data!.docs[index];
                              return Column(
                                children: [
                                  // Titel
                                  Column(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.45,
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(20.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                data['urlToImage']),
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.5),
                                              BlendMode.darken,
                                            ),
                                          ),
                                          color: Colors.transparent,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomTag(
                                                  backgroundColor: Colors.grey
                                                      .withAlpha(150),
                                                  children: [
                                                    Text(
                                                      'News of the Day',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  data['title'],
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  data['description'],
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    nextScreen(context,
                                                        ArticleScreen());
                                                  },
                                                  style: TextButton.styleFrom(
                                                      padding:
                                                          EdgeInsets.all(0)),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        ' Learn More ',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .copyWith(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      ), // Text
                                                      const SizedBox(width: 10),
                                                      const Icon(
                                                        Icons.arrow_right_alt,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // (News und More) Überschrift
                                                Text(
                                                  'News',
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),

                                                const SizedBox(height: 16),

                                                // Mehrere Artikel
                                                SizedBox(
                                                  height: 310,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      padding: EdgeInsets.zero,
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      itemCount: snapshot
                                                          .data!.docs.length,
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var data = snapshot
                                                            .data!.docs[index];
                                                        // Artikel
                                                        return InkWell(
                                                          onTap: () {
                                                            nextScreen(context,
                                                                ArticleScreen());
                                                          },
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.5,
                                                                height: 150,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  top: 10.0,
                                                                  right: 25.0,
                                                                  bottom: 10.0,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            20),
                                                                  ),
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        NetworkImage(
                                                                      data[
                                                                          'urlToImage'],
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.5,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      data[
                                                                          'title'],
                                                                      style: GoogleFonts
                                                                          .montserrat(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      data[
                                                                          'description'],
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                      style: GoogleFonts
                                                                          .montserrat(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    Text(
                                                                      data[
                                                                          'time'],
                                                                      style: GoogleFonts
                                                                          .montserrat(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    Text(
                                                                      data[
                                                                          'author'],
                                                                      style: GoogleFonts
                                                                          .montserrat(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              );
                            });
                      } else {
                        return Center(child: Text('Keine Artikel vorhanden'));
                      }
                    }),
              ],
            ),
    );
  }
}
