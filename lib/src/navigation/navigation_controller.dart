import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigationController {
  //final lines = Lines();
  double tamCircle = 300;

  LatLng? lugarCirculo;
  Map<CircleId, Circle> myCircle = {};
  List<Marker> myMarkers = [];

  Set<Circle> get getCircle => (myCircle.values.toSet());

  Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();

  
  var id = 0;

  
  final Map<PolylineId, Polyline> polylines = {};
  List<LatLng> listPosition = [];
  String draw = 'No';



  // show a circle where user clicked
  void showCircle(posicion) {
    id++;
    CircleId c = CircleId(id.toString());
    Circle circulo = Circle(
        circleId: c,
        center: posicion,
        radius: tamCircle,
        strokeWidth: 2,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withAlpha(70));
    myCircle[c] = circulo;
  }

  // markers
  void addMarker(LatLng position, double colorMarker, String infoMarker) {
    MarkerId markerId = MarkerId(position.toString());
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(colorMarker),
      infoWindow: InfoWindow(
        title: infoMarker,
      ),
      draggable: true,
    );
    _markers[markerId] = marker;
  }

  void loadStops(lines) {
    lines.forEach((data) {
      final Li = data['LI'];
      addMarker(
          LatLng(Li["coordenadas"][0]["latitud"],
              Li["coordenadas"][0]["longitud"]),
          BitmapDescriptor.hueRed,
          data['name']);

      addMarker(
          LatLng(Li["coordenadas"][Li["coordenadas"].length - 1]["latitud"],
              Li["coordenadas"][Li["coordenadas"].length - 1]["longitud"]),
          BitmapDescriptor.hueRed,
          data['name']);
    });
  }

  void loadRoute(var result) {
    loadPositions(result);
    loadPolylines();
  }

  void loadPositions(List<dynamic> result) {
    listPosition.clear();
    List<String> ar2 = result[result.length - 1][0].split(',');
    double lat = double.parse(ar2[1]);
    double long = double.parse(ar2[0]);
    LatLng finalpoint = LatLng(lat, long);
    for (var i = 0; i < result.length; i++) {
      var element = result[i];
      List<String> ar = element[0].split(',');
      double lat = double.parse(ar[1]);
      double long = double.parse(ar[0]);
      LatLng point = LatLng(lat, long);
      if (passInPosition(finalpoint, point) && i + 10 < result.length) {
        break;
      }
      listPosition.add(point);
    }
  }

  void loadPolylines() {
    polylines.clear();
    PolylineId polylineId = const PolylineId('id1');
    Polyline polyline = Polyline(
      polylineId: polylineId,
      points: listPosition,
      color: Colors.blue,
      width: 3,
    );
    polylines[polylineId] = polyline;
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

  bool passInPosition(LatLng punto, LatLng pos) {
    double dist = getDistanceBetweenPointsNew(
        punto.latitude, punto.longitude, pos.latitude, pos.longitude);
    if (dist <= 100) {
      return true;
    }
    return false;
  }

  List<dynamic> transbordos(var result) {
    markers.clear();
    List<dynamic> coord = [];
    List<dynamic> datos = [];
    result.forEach((element) {
      if (element[1] != null) {
        List<String> ar = element[0].split(',');
        List<String> ar1 = element[1].split(',');
        coord.add([
          {'lat': double.parse(ar[1]), 'lng': double.parse(ar[0])},
          {'lat': double.parse(ar1[1]), 'lng': double.parse(ar1[0])},
          element[2]
        ]);
      }
    });
    print(coord);
    String linea = coord[0][2]['codes'][0];
    //Marcador
    LatLng po = LatLng(0, 0);
    addMarker(listPosition.first, BitmapDescriptor.hueRed, linea);
    //-----------------------------
    int transbordos = 0;
    int micros = 1;
    for (var i = 0; i < coord.length; i++) {
      if (i < listPosition.length) {
        List<dynamic> point = coord[i];
        if (i <= coord.length - 2) {
          if (point[2]['codes'].indexOf(linea) == -1) {
            transbordos++;
            micros++;
            int i = point[2]['codes'].length;
            bool b = false;
            int x = 0;
            print(linea);
            datos.add(linea);
            print(point[2]['codes']);
            print(coord[i + 1][2]['codes']);
            while (x <= i - 1 && b == false) {
              linea = point[2]['codes'][x];
              if (coord[i + 1][2]['codes'].indexOf(linea) != -1) {
                b = true;
              }
              x = x + 1;
            }
            //Marcador
            po = LatLng(point[0]['lat'], point[0]['lng']);
            addMarker(po, BitmapDescriptor.hueRed, linea);
            //-----------------------------
          }
        }
      }
    }
    //Marcador
    addMarker(listPosition.last, BitmapDescriptor.hueGreen, "Punto de llegada");
    //-----------------------------
    datos.add(linea);
    return datos;
  }
}
