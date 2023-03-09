import 'package:cloud_firestore/cloud_firestore.dart';

class Linea {
  String? name;
  LV? lV;
  String? id;
  LV? lI;
  String? image;

  Linea({this.name, this.lV, this.id, this.lI, this.image});

  factory Linea.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Linea.fromJson(data!);
  }

  Linea.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lV = json['LV'] != null ? new LV.fromJson(json['LV']) : null;
    id = json['id'];
    lI = json['LI'] != null ? new LV.fromJson(json['LI']) : null;
    image = json['image'];
  }

/*  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (state != null) "state": state,
      if (country != null) "country": country,
      if (capital != null) "capital": capital,
      if (population != null) "population": population,
      if (regions != null) "regions": regions,
    };
  }*/

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.lV != null) {
      data['LV'] = this.lV!.toJson();
    }
    data['id'] = this.id;
    if (this.lI != null) {
      data['LI'] = this.lI!.toJson();
    }
    data['image'] = this.image;
    return data;
  }
}

class LV {
  String? oneway;
  double? tiempo;
  double? shapeLen;
  List<Coordenadas>? coordenadas;
  int? oBJECTID;
  double? distancia;

  LV(
      {this.oneway,
        this.tiempo,
        this.shapeLen,
        this.coordenadas,
        this.oBJECTID,
        this.distancia});

  LV.fromJson(Map<String, dynamic> json) {
    oneway = json['oneway'];
    tiempo = json['tiempo']+0.0;
    shapeLen = json['Shape_Len'];
    if (json['coordenadas'] != null) {
      coordenadas = <Coordenadas>[];
      json['coordenadas'].forEach((v) {
        coordenadas!.add(new Coordenadas.fromJson(v));
      });
    }
    oBJECTID = json['OBJECTID'];
    distancia = json['distancia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oneway'] = this.oneway;
    data['tiempo'] = this.tiempo;
    data['Shape_Len'] = this.shapeLen;
    if (this.coordenadas != null) {
      data['coordenadas'] = this.coordenadas!.map((v) => v.toJson()).toList();
    }
    data['OBJECTID'] = this.oBJECTID;
    data['distancia'] = this.distancia;
    return data;
  }
}

class Coordenadas {
  double? longitud;
  double? latitud;

  Coordenadas({this.longitud, this.latitud});

  Coordenadas.fromJson(Map<String, dynamic> json) {
    longitud = json['longitud'];
    latitud = json['latitud'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['longitud'] = this.longitud;
    data['latitud'] = this.latitud;
    return data;
  }
}