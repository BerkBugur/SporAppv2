import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Person")
            .orderBy('totalDistance', descending: true)
            .limit(50) // Top 50
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var sayi = 1;
          return ListView(
            children: snapshot.data!.docs.map((document) {
              if (sayi == 1) {
                return Container(
                  child: ListTile(
                    title: Text(document['userName']),
                    subtitle:
                        Text("${document['totalDistance'].toString()}" + " Km"),
                    leading: Text(("${sayi++}" + "#").toString()),
                    trailing:
                        Icon(FontAwesomeIcons.trophy, color: Colors.amber),
                  ),
                );
              } else if (sayi == 2) {
                return Container(
                  child: ListTile(
                    title: Text(document['userName']),
                    subtitle:
                        Text("${document['totalDistance'].toString()}" + " Km"),
                    leading: Text(("${sayi++}" + "#").toString()),
                    trailing: Icon(FontAwesomeIcons.trophy, color: Colors.grey),
                  ),
                );
              } else if (sayi == 3) {
                return Container(
                  child: ListTile(
                    title: Text(document['userName']),
                    subtitle:
                        Text("${document['totalDistance'].toString()}" + " Km"),
                    leading: Text(("${sayi++}" + "#").toString()),
                    trailing: Icon(FontAwesomeIcons.trophy,
                        color: Colors.deepOrangeAccent),
                  ),
                );
              }
              return Container(
                child: ListTile(
                  title: Text(document['userName']),
                  subtitle:
                      Text("${document['totalDistance'].toString()}" + " Km"),
                  leading: Text(("${sayi++}" + "#").toString()),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
