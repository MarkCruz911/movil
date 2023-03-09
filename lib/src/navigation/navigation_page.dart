import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'navigation_controller.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  NavigationController navigationController = NavigationController();
  LatLng CoordOrig = LatLng(0, 0);
  LatLng CoordDest = LatLng(0, 0);
  var c = 0;
  List<dynamic> result = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              label: const Text('Calcular Ruta'),
              backgroundColor: Colors.grey,
              onPressed: () {
                GetPoints(CoordOrig, CoordDest);
              },
            ),
          ],
        ),
        appBar: AppBar(
          title: Text("Marcar Puntos"),
          backgroundColor: Colors.indigoAccent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: const CameraPosition(
                target: LatLng(-17.78629, -63.18117),
                zoom: 12.4746,
              ),
              onTap: _handleTap,
              markers: navigationController.markers,
              circles: navigationController.getCircle,
            ),
          ],
        ));
  }

  _handleTap(LatLng tappedPoint) {
    c++;
    if (c == 1) {
      CoordOrig = tappedPoint;
      setState(() {
        navigationController.showCircle(tappedPoint);
        navigationController.addMarker(
            tappedPoint, BitmapDescriptor.hueRed, tappedPoint.toString());
      });
    } else {
      if (c == 2) {
        CoordDest = tappedPoint;
        setState(() {
          navigationController.showCircle(tappedPoint);
          navigationController.addMarker(
              tappedPoint, BitmapDescriptor.hueGreen, tappedPoint.toString());
        });
      }
    }
  }

  void GetPoints(LatLng orig, LatLng dest) async {
    List<dynamic> data = [];
    List<dynamic> puntosOrig = [];
    List<dynamic> puntosDest = [];
    rootBundle.loadString('data/All2.json').then((value) async {
      data = jsonDecode(value);
      data.forEach((element) {
        bool b1 = passInPosition(element, orig);
        if (b1) {
          puntosOrig.add(element);
        }
        bool b2 = passInPosition(element, dest);
        if (b2) {
          puntosDest.add(element);
        }
      });
      if (puntosOrig.length != 0 && puntosDest.length != 0) {
        http.Client client = http.Client();
        try {
          http.Response response = await client
              .post(Uri.parse('https://carlos.sw1.lol/puntos'), body: {
            "lati": puntosOrig[0]['longi'],
            "longi": puntosOrig[0]['lati'],
            "latid": puntosDest[0]['longi'],
            "longid": puntosDest[0]['lati'],
          });
          if (response.statusCode >= 200 && response.statusCode < 300) {
            result = jsonDecode(response.body);
          } else {
            ('Error al consumir la API: código de estado ${response.statusCode}');
          }
        } catch (e) {
          ('Error al consumir la API: $e');
        } finally {
          client.close();
        }
        Navigator.pushNamed(context, 'mapa', arguments: result);
      } else {
        setState(() {
          navigationController.markers.clear();
        });
      }
    });
  }

  double distanceAB(LatLng a, LatLng b) {
    double x = (b.longitude - a.longitude);
    double y = (b.latitude - a.latitude);
    double dist = sqrt(pow(x, 2) + pow(y, 2));
    return dist;
  }

  bool passInPosition(var data, LatLng pos) {
    double long = double.parse(data['longi']);
    double lat = double.parse(data['lati']);
    LatLng punto = LatLng(lat, long);
    double dist = getDistanceBetweenPointsNew(
        punto.latitude, punto.longitude, pos.latitude, pos.longitude);
    if (dist <= 300) {
      return true;
    }
    return false;
  }

  double getDistanceBetweenPointsNew(double latitude1, double longitude1,
      double latitude2, double longitude2) {
    double theta = longitude1 - longitude2;
    double distance = 60 *
        1.1515 *
        (180 / pi) *
        acos(sin(latitude1 * (pi / 180)) * sin(latitude2 * (pi / 180)) +
            cos(latitude1 * (pi / 180)) *
                cos(latitude2 * (pi / 180)) *
                cos(theta * (pi / 180)));
    return distance * 1.609344 * 1000;
  }

/*  void _agrandarCirculo() {
    setState(() {
      if (tamCircle == 400) {
        tamCircle = 100;
      } else {
        tamCircle = tamCircle + 100;
      }
      cargarCircle(lugarCirculo);
    });
  }*/

/*  void _circuloEnMiUbicacion() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled!) return;
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted != PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }
    _locationData = await location.getLocation();
    setState(() {
      _isGetLocation = true;
      final p = LatLng(_locationData!.latitude!, _locationData!.longitude!);
      lugarCirculo = p;
      cargarCircle(p);
      _controllerDistance.addLinesOnCircle(p);
      _controllerLineas.cargarLista(_controllerDistance.lineasOnCircle);
      _controllerLineas.uploadRoute();
    });
  }*/

/*  Widget button(function, IconData icon, String description) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: Colors.blue,
      child: Tooltip(
          message: description,
          child: Icon(
            icon,
            size: 30.0,
          )),
    );
  }*/

}
