import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/linea.dart';

class HomeMap extends StatefulWidget {
  const HomeMap({Key? key}) : super(key: key);

  @override
  State<HomeMap> createState() => _HomeMapState();
  
}

class _HomeMapState extends State<HomeMap> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('lineas')
      .withConverter(
        fromFirestore: Linea.fromFirestore,
        toFirestore: (Linea linea, _) => linea.toFirestore(),
      )
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Linea linea = document.data()! as Linea;
                return ListTile(
                  title: Text(linea.name ?? ""),
                  subtitle: Text(linea.id ?? ""),
                );
              })
              .toList()
              .cast(),
        );
      },
    );
  }
}
