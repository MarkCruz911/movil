import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'navigation_controller.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({Key? key}) : super(key: key);

  @override
  State<MapaPage> createState() => _MapaPage();
}

class _MapaPage extends State<MapaPage> {
  NavigationController navigationController = NavigationController();

  @override
  Widget build(BuildContext context) {
    List<dynamic> result =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    navigationController.loadRoute(result);
    List<dynamic> datos = navigationController.transbordos(result);
    print('datos:');
    print(datos);
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              label: const Text('Ver Líneas'),
              backgroundColor: Colors.grey,
              onPressed: () {
                _showDialog(context, datos);
              },
            ),
          ],
        ),
        appBar: AppBar(
          title: const Text("Ruta"),
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
              markers: navigationController.markers,
              polylines: navigationController.polylines.values.toSet(),
            ),
          ],
        ));
  }

  void _showDialog(BuildContext context, List<dynamic> datos) {
    var num = datos.length - 1;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Transbordos: " + num.toString()),
            children: _listItems(datos),
          );
        });
  }

  List<Widget> _listItems(List<dynamic> datos) {
    final List<Widget> optValueWidget = [];
    datos.forEach((element) {
      final widgetValue = ListTile(
        title: Text(element),
        leading: Icon(Icons.bus_alert),
        onTap: () {
          Navigator.pop(context);
        },
      );
      optValueWidget.add(widgetValue);
    });
    return optValueWidget;
  }
}
