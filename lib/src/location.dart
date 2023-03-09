import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_database/firebase_database.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _location = Location();
  late GoogleMapController _mapController;
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String _locationData = "Unknown";

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 2,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          //_database.reference().child("location").onValue.listen((event) {
            //setState(() {
              //event.snapshot.value;
             // _locationData = event.snapshot.value;
            //});
          //  _updateMap();
         // });
        },
      ),
    );
  }

  void _getLocation() async {
    LocationData locationData = await _location.getLocation();
    setState(() {
      _locationData = "${locationData.latitude}, ${locationData.longitude}";
    });
    _database.reference().child("location").set(_locationData);
  }

  //void _updateMap() {
  //  _mapController.clearMarkers();
  //  var latLng = _locationData.split(", ");
  //  var marker = MarkerOptions(
  //    position: LatLng(double.parse(latLng[0]), double.parse(latLng[1])),
  //  );
  //  _mapController.addMarker(marker);
  //}
}
