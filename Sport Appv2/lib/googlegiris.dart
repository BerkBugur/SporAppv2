import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _googleSignIn.currentUser;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
              'Google sign in (Signed' + (user == null ? 'out' : 'in') + ')'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  child: Text("Sign In"),
                  onPressed: () async {
                    await _googleSignIn.signIn();
                    setState(() {});
                  }),
              ElevatedButton(
                  child: Text("Sign Out"),
                  onPressed: () async {
                    await _googleSignIn.signOut();
                    setState(() {});
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
