import 'package:esgarden/Models/Plot.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class formGeoloc extends StatefulWidget {
  Plot PlotKey;

  formGeoloc({this.PlotKey});

  @override
  _formGeolocState createState() => _formGeolocState();
}

class _formGeolocState extends State<formGeoloc> {
  GoogleMapController mapController;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    print(controller.getZoomLevel());
  }

  _findLocation() {
    var dbref = _database
        .reference()
        .child('Gardens')
        .child(widget.PlotKey.parent)
        .child('Latitude');

    dbref.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      print(values["Latitude"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Geolocalization'),
          backgroundColor: Colors.green,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}
