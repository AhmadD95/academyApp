import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewsTestPage extends StatefulWidget {
  const NewsTestPage({super.key});

  @override
  State<NewsTestPage> createState() => _NewsTestPageState();
}

class _NewsTestPageState extends State<NewsTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(),
        backgroundColor: Color.fromARGB(255, 1, 138, 190),
        elevation: 0,
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("articles").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index];
                        return Column(
                          children: [
                            Image.network(data['urlToImage']),
                            Text(data['author']),
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
