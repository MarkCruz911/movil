import 'package:bus_client/src/maps/MarkerController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import '../models/linea.dart';
import 'package:location/location.dart';

final docTour = FirebaseFirestore.instance.collection('usuarios').where('rol',isEqualTo:'Chofer').where('activo',isEqualTo: true);




class TourMap extends StatefulWidget {
  const TourMap({Key? key}) : super(key: key);

  @override
  State<TourMap> createState() => _TourMapState();
}

class _TourMapState extends State<TourMap> {
  MarkerController markerController=MarkerController();
  List tours = [];
  var bandera = false;

@override
void initState(){
  super.initState();
  markerController.setCustomMapPin();
  docTour.snapshots().listen((event) {
    tours.clear();
    for(var doc in event.docs){
      tours.add(doc.data());
    }
    setState(() {
      
    });
  });
}


  @override
  Widget build(BuildContext context) {
    Linea linea = ModalRoute.of(context)!.settings.arguments as Linea;
    markerController.loadRoute(linea);

    tours.forEach((bus){
      
      print("-----------------------------------------------------------------");
      print(bus);
      if(bus['linea']==linea.name){
      markerController.loadBus(bus);
      }
    });
    //obtener los usuarios que pertenezcan a la linea recibida por argumento, los usuarios de la base de datos de firestore de la misma linea
    
    //
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            label: const Text('Ruta de ida'),
            backgroundColor: markerController.direction == 'Ida'
                ?  Colors.blue
                : Colors.grey,
            onPressed: () {
              setState(() {
                markerController.direction="Ida";
              });
            },
          ),
          FloatingActionButton.extended(
          label: const Text('Ruta de vuelta'),
          backgroundColor: markerController.direction == 'Vuelta'
          ? Colors.blue
              : Colors.grey,
            onPressed: (){
              setState(() {
                markerController.direction="Vuelta";
              });
            },
          ),
          FloatingActionButton.extended(
          label: const Text('En Marcha'),
          backgroundColor:Colors.green,
            onPressed: (){
              bandera = true;
              iniciarReccorrido();
            },
          ),
          FloatingActionButton.extended(
          label: const Text('No Marcha'),
          backgroundColor:Colors.red,
            onPressed: (){
              bandera = false;
              iniciarReccorrido();
            },
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(linea.name??"Linea"),
        elevation: 0,
      ),
      body: GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        initialCameraPosition: markerController.initialCameraPosition,
        onMapCreated: (mapController) {
          mapController.showMarkerInfoWindow(MarkerId("Parada Inicio"));
        },
        markers: markerController.markers,
        polylines: markerController.polylines.values.toSet(),
      ),
    );
  }
  void iniciarReccorrido()async{

  if(bandera){

  try {
    final timer = Timer(
  const Duration(seconds: 10),
  () async {
    Location location = Location();
    LocationData currentLocation = LocationData.fromMap({
    'latitude': 0.0,
    'longitude': 0.0,
  });

    currentLocation = await location.getLocation();
    double? latitude = currentLocation.latitude;
    double? longitude = currentLocation.longitude;
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    user?.uid;

    CollectionReference users = FirebaseFirestore.instance.collection('usuarios');

     users
    .doc(user?.uid)
    .update({'latitud': latitude,'logitud':longitude,'activo':true})
    .then((value) => print("Usuario Actualizado"))
    .catchError((error) => print("falla de Actualizacion de usuario: $error"));
  },
);


  } catch (e) {
    Location location = Location();
    LocationData currentLocation = LocationData.fromMap({
    'latitude': 0.0,
    'longitude': 0.0,
  });
    currentLocation = LocationData.fromMap({
    'latitude': 0.0,
    'longitude': 0.0,

    });
  }
  }else{
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    user?.uid;

    CollectionReference users = FirebaseFirestore.instance.collection('usuarios');

     users
    .doc(user?.uid)
    .update({'activo':false})
    .then((value) => print("Usuario Actualizado"))
    .catchError((error) => print("falla de Actualizacion de usuario: $error"));
  }

  }

}
