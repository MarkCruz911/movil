import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

import '../models/linea.dart';

class MarkerController{
  Set<Marker> markers = {};
  String direction='Ida';

  final Map<PolylineId, Polyline> polylines = {};

  final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(-17.783113, -63.181359),
    zoom: 14.2,
  );

  List<LatLng> listPosition = [];
  dynamic pinLocationIcon;


  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1),
        'assets/icon_bus.png');
  }

  void addMarker(LatLng position, double colorMarker, String infoMarker) {
    markers.add(Marker(
      markerId: MarkerId(infoMarker),
      position: position,
      icon: infoMarker=='micro'?pinLocationIcon:BitmapDescriptor.defaultMarkerWithHue(colorMarker),
      infoWindow: InfoWindow(
        title: infoMarker,
      ),
      draggable: true,
    ));
  }

  void loadRoute(Linea linea){
    loadPositions(linea);
    loadStops(linea);
    loadPolylines();
  }

  void loadBus(bus){
    var latitud = bus["latitud"];
    var longitud = bus["logitud"];
    
    if(latitud !=null && longitud != null){
      print("llllllllllllllllllllllllllllllllllll");
    addMarker(
        LatLng(latitud, longitud),
        BitmapDescriptor.hueRed,
        "micro");
        }
  }



  void loadStops(Linea linea) {
    markers.clear();
    final LV? coordinates = direction=='Ida'?linea.lI:linea.lV;

    var first= coordinates?.coordenadas?.first;
    var last= coordinates?.coordenadas?.elementAt((coordinates?.coordenadas?.length??1)-1);
    addMarker(
        LatLng(
            first?.latitud??0, first?.longitud??0,),
        BitmapDescriptor.hueRed,
        "Parada Inicio");

    addMarker(
        LatLng(
              last?.latitud??0, last?.longitud??0,),
        BitmapDescriptor.hueGreen,
        "Parada Fin");
  }

  void loadPositions(Linea linea) {
    listPosition.clear();
    final LV? coordinates = direction=='Ida'?linea.lI:linea.lV;

    coordinates?.coordenadas?.forEach((cordenada) {
      LatLng position = LatLng(cordenada.latitud??0, cordenada.longitud??0);
      listPosition.add(position);
    });
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

}