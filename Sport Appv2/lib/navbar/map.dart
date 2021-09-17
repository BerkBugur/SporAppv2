import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spor_app/navbar/dashboard.dart';
import 'package:spor_app/navbar/direction_model.dart';
import 'package:spor_app/navbar/directions_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spor_app/main.dart';
import 'package:spor_app/navbar/nav.dart';

var poli;
var duration;
var distance;
bool buton = true;
var baslabutton = Icons.play_arrow;
var durbutton = Icons.pause;
var butondurum = Icons.play_arrow;
var docId;
var tempDis;
var tempDur;
var tempAct;

CollectionReference users = FirebaseFirestore.instance.collection('Activity');
CollectionReference person = FirebaseFirestore.instance.collection('Person');
Timestamp now = new Timestamp.now();

Future<void> updateDashboard() async {
  var collection = FirebaseFirestore.instance.collection('Person');
  var docSnapshot = await collection.doc(userToken).get();
  Map<String, dynamic>? data = docSnapshot.data();

  tempDis = data!["totalDistance"];
  tempAct = data["totalActivity"];
  tempDur = data["totalDuration"];

  tempDis = tempDis + distance;
  tempAct = tempAct + 1;
  tempDur = tempDur + duration;

  //print(tempDis + tempAct + tempDur);

  collection.doc(userToken) // <-- Doc ID where data should be updated.
      .update({
    'totalDistance': tempDis,
    'totalActivity': tempAct,
    'totalDuration': tempDur,
  });
}

Future<void> addActivity() {
  return users
      .doc()
      .set(
        {
          'userEmail': userId,
          'Duration': duration,
          'distance': distance,
          'StartDate': now,
          'FinishDate': now,
        },
        SetOptions(merge: true),
      )
      .then((value) => docId = users.id)
      .catchError((error) => print("Failed to merge data: $error"));
}

Future<void> updateActivity() {
  return users
      .doc(users.doc().id)
      .update({'FinishDate': now})
      .then((value) => print(docId))
      .catchError((error) => print("Failed to update user: $error"));
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(39.9035557, 32.6226796),
    zoom: 11.5,
  );
  Marker _destination = Marker(markerId: MarkerId("destination"));
  Marker _origin = Marker(
    markerId: const MarkerId("origin"),
    infoWindow: const InfoWindow(title: "Konumunuz"),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    position: LatLng(39.9035557, 32.6226796),
  );
  late Directions _info = Directions(
      bounds: bounds,
      polylinePoints: polylinePoints,
      totalDistance: totalDistance,
      totalDuration: totalDuration);

  late GoogleMapController _googleMapController;

  static get bounds => null;

  static get polylinePoints => null;

  static get totalDistance => null;

  static get totalDuration => null;

  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            myLocationEnabled: false,
            mapToolbarEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) {
              _googleMapController = controller;
              _googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(_initialCameraPosition));
            },
            markers: {
              _origin,
              _destination = _destination,
            },
            polylines: {if (poli != null) poli},
            onLongPress: _addMarker,
          ),
          Positioned(
            top: 20.0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 12.0,
              ),
              decoration: BoxDecoration(
                color: Colors.yellowAccent,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  )
                ],
              ),
              child: Text(
                '${_info.totalDistance}, ${_info.totalDuration}',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
        onPressed: () {
          setState(() {
            if (buton == true) {
              butondurum = baslabutton;
              distance = _info.totalDistance;
              duration = _info.totalDuration;
              distance = distance.split(" ");
              duration = duration.split(" ");
              duration = duration[0];
              distance = distance[0];
              distance = double.parse(distance.toString());
              duration = int.parse(duration.toString());
              addActivity();
              buton = false;
            } else {
              //Counter eklenmeli dashboard güncellemesi için
              updateActivity();
              updateDashboard();
              butondurum = durbutton;
              buton = true;
            }
          });
        },
        child: Icon(butondurum),
      ),
    );
  }

  Future<void> _addMarker(LatLng pos) async {
    setState(() {
      _destination = Marker(
        markerId: const MarkerId("destination"),
        infoWindow: const InfoWindow(title: "Hedef"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: pos,
      );
    });
    final directions = await DirectionsRepository()
        .getDirections(origin: _origin.position, destination: pos);
    setState(() => _info = directions);

    poli = Polyline(
      polylineId: const PolylineId('overview_polyline'),
      color: Colors.red,
      width: 5,
      points: _info.polylinePoints
          .map((e) => LatLng(e.latitude, e.longitude))
          .toList(),
    );
  }
}
