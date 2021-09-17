import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:spor_app/navbar/nav.dart';
import 'package:intl/intl.dart';

var documentId = "";
int saat = 20;
var gunici;
var guniciphoto = "";

class Activity extends StatefulWidget {
  const Activity({Key? key}) : super(key: key);

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  DateTime now = new DateTime.now();

  get post => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Activity").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var sayi = 1;
          return ListView(
            children: snapshot.data!.docs.map((document) {
              if (document['userEmail'] == userId) {
                DateTime myDateTime = (document['StartDate']).toDate();
                String formattedDate =
                    DateFormat('dd-MM-yyyy – kk:mm').format(myDateTime);
                var gunSaati = formattedDate;
                gunSaati.split("");
                gunSaati = gunSaati[13] + gunSaati[14];
                var yenigunSaati = int.parse(gunSaati.toString());

                return Container(
                  child: ListTile(
                      title: Text(formattedDate.toString()),
                      subtitle: Text("Yürünen mesafe: " +
                          document['distance'].toString() +
                          " km"),
                      leading: Text(("${sayi++}" + "#")
                          .toString()), //Text(document['distance'].toString()),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        documentId = document.id;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(
                                      post: document,
                                    )));
                      }),
                );
              }
              return Container(
                child: Text(""),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;
  DetailPage({required this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  num? get yenigunSaati => 12;

  @override
  Widget build(BuildContext context) {
    if (yenigunSaati! < 12) {
      gunici = Colors.yellowAccent.shade400;
      guniciphoto = './assets/sabah.jpg';
    } else if (yenigunSaati! >= 12 && yenigunSaati! <= 17) {
      gunici = Colors.orange;
      guniciphoto = './assets/oglen.jpg';
    } else {
      gunici = Colors.blueGrey;
      guniciphoto = './assets/aksam.jpg';
    }
    DateTime AStartDateTime = (widget.post['StartDate']).toDate();
    String AStartformattedDate =
        DateFormat('dd-MM-yyyy – kk:mm').format(AStartDateTime);
    DateTime AFinishtDateTime = (widget.post['FinishDate']).toDate();
    String AFinishformattedDate =
        DateFormat('dd-MM-yyyy – kk:mm').format(AFinishtDateTime);
    return Material(
      color: gunici,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 50,
                  height: 200,
                  alignment: Alignment.center,
                  child: Text(
                    "Başlangıç Zamanı:" + "\n\n" + AStartformattedDate,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: 100,
                  height: 200,
                  alignment: Alignment.center,
                  child: Text(
                    "Bitiş Zamanı:" + "\n\n" + AFinishformattedDate,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Image(
                  image: AssetImage(guniciphoto),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 50,
                  height: 100,
                  alignment: Alignment.center,
                  child: Text(
                    "Katedilen Mesafe:  " +
                        widget.post["distance"].toString() +
                        " Km",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 50,
                  height: 100,
                  alignment: Alignment.center,
                  child: Text(
                    "Geçen Süre:  " +
                        widget.post["Duration"].toString() +
                        " Dakika",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 50,
                  height: 100,
                  alignment: Alignment.center,
                  child: Text(
                    "Tahmini Harcanan Kalori:  " +
                        (widget.post["Duration"] * 5).toString() +
                        " Cal", // Hızlı yürüyüşte tahmini dakikkada ortalama 5 cal yakılıyor. Kişinin kilosuna yağ oranına bağlı değişiklik göstermektedir.
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  onPressed: () {
                    Share.share("Merhaba ${AStartformattedDate} tarihinde " +
                        widget.post["distance"].toString() +
                        " km yürüyüş yaptım. Sende davetlisin.");
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Arkadaşlarınla paylaş  ",
                        ),
                        WidgetSpan(
                          child: Icon(Icons.share, size: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
