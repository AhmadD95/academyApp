import 'package:academy/widgets/image_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:academy/widgets/custom_tag.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_tag.dart';
import '../widgets/navigation_drawer.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("articles").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
              scrollDirection: Axis.vertical,
              separatorBuilder: (context, index) => const Divider(),
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemCount: 1,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return imageContainer(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  imageUrl: data['urlToImage'],
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      scrolledUnderElevation: 1,
                      shadowColor: Color.fromARGB(255, 1, 138, 190),
                      iconTheme: const IconThemeData(color: Colors.white),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    extendBodyBehindAppBar: true,
                    body: ListView(
                      children: [
                        Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.10),
                                  Text(
                                    data['title'],
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22,
                                      color: Colors.white,
                                      height: 1.25,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    data['description'],
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Colors.white,
                                      height: 1.25,
                                    ),
                                  )
                                ]),
                          )
                        ]),
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomTag(
                                        backgroundColor:
                                            Color.fromARGB(255, 1, 138, 190),
                                        children: [
                                          Icon(
                                            Icons.account_circle_outlined,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            data['author'],
                                            style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ]),
                                    SizedBox(width: 10),
                                    CustomTag(
                                        backgroundColor: Colors.grey.shade200,
                                        children: [
                                          Icon(
                                            Icons.schedule,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            data['time'],
                                            style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ]),
                                  ]),
                              SizedBox(height: 20),
                              Text(
                                data['title'],
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                data['content'],
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        } else {
          return Center(child: Text('Keine Artikel vorhanden'));
        }
      },
    );

    // Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.transparent,
    //     elevation: 0,
    //   ),
    //   bottomNavigationBar: ButtomNavBar(index: 0),
    //   extendBodyBehindAppBar: true,
    //   drawer: NavigationDrawer(),
    //   body: ListView(
    //     padding: EdgeInsets.zero,
    //     children: [
    //       StreamBuilder(
    //           stream:
    //               FirebaseFirestore.instance.collection("articles").snapshots(),
    //           builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //             if (snapshot.hasData) {
    //               return ListView.separated(
    //                   scrollDirection: Axis.vertical,
    //                   separatorBuilder: (context, index) => const Divider(),
    //                   padding: EdgeInsets.zero,
    //                   physics: const BouncingScrollPhysics(),
    //                   itemCount: 1,
    //                   shrinkWrap: true,
    //                   itemBuilder: (context, index) {
    //                     var data = snapshot.data!.docs[index];
    //                     return Column(
    //                       children: [
    //                         // Titel
    //                         Container(
    //                           height: MediaQuery.of(context).size.height * 0.45,
    //                           width: double.infinity,
    //                           padding: const EdgeInsets.all(20.0),
    //                           decoration: BoxDecoration(
    //                             borderRadius: BorderRadius.only(
    //                                 bottomLeft: Radius.circular(20),
    //                                 bottomRight: Radius.circular(20)),
    //                             image: DecorationImage(
    //                               image: NetworkImage(data['urlToImage']),
    //                               fit: BoxFit.cover,
    //                               colorFilter: ColorFilter.mode(
    //                                 Colors.black.withOpacity(0.5),
    //                                 BlendMode.darken,
    //                               ),
    //                             ),
    //                             color: Colors.transparent,
    //                           ),
    //                           child: Column(
    //                             mainAxisAlignment: MainAxisAlignment.end,
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               CustomTag(
    //                                 backgroundColor: Colors.grey.withAlpha(150),
    //                                 children: [
    //                                   Text(
    //                                     'News of the Day',
    //                                     style: GoogleFonts.montserrat(
    //                                       fontSize: 12,
    //                                       color: Colors.white,
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                               const SizedBox(height: 10),
    //                               Text(
    //                                 data['name'],
    //                                 style: GoogleFonts.montserrat(
    //                                   fontSize: 24,
    //                                   fontWeight: FontWeight.w700,
    //                                   color: Colors.white,
    //                                 ),
    //                               ),
    //                               const SizedBox(height: 10),
    //                               Text(
    //                                 data['title'],
    //                                 style: GoogleFonts.montserrat(
    //                                   fontSize: 20,
    //                                   fontWeight: FontWeight.w700,
    //                                   color: Colors.white,
    //                                 ),
    //                               ),
    //                               TextButton(
    //                                 onPressed: () {},
    //                                 style: TextButton.styleFrom(
    //                                     padding: EdgeInsets.all(0)),
    //                                 child: Row(
    //                                   children: [
    //                                     Text(
    //                                       ' Learn More ',
    //                                       style: Theme.of(context)
    //                                           .textTheme
    //                                           .bodyLarge!
    //                                           .copyWith(
    //                                             color: Colors.white,
    //                                           ),
    //                                     ), // Text
    //                                     const SizedBox(width: 10),
    //                                     const Icon(
    //                                       Icons.arrow_right_alt,
    //                                       color: Colors.white,
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     );
    //                   });
    //             } else {
    //               return Center(child: Text('Keine Artikel vorhanden'));
    //             }
    //           }),
    //     ],
    //   ),
    // );
  }
}
