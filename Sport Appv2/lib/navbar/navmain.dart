import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spor_app/navbar/nav.dart';
import 'dart:developer';

class NavApp extends StatefulWidget {
  const NavApp({Key? key}) : super(key: key);

  @override
  _NavAppState createState() => _NavAppState();
}

class _NavAppState extends State<NavApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sport App',
      home: Nav(),
    );
  }
}
