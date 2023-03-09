import 'package:bus_client/src/buses/home_bus.dart';
import 'package:bus_client/src/home.dart';
import 'package:bus_client/src/login.dart';
import 'package:bus_client/src/maps/home_map.dart';
import 'package:bus_client/src/maps/tour_map.dart';
import 'package:bus_client/src/register.dart';
import 'package:flutter/material.dart';
import '../navigation/mapa_page.dart';
import '../navigation/navigation_page.dart';

class Routes {
  static const initialRoute = 'home';
  static final Map<String, Widget Function(BuildContext)> routes = {
    'home': (BuildContext context) => const Home(),
    'login': (BuildContext context) => const Login(),
    'register': (BuildContext context) => const Register(),
    'home_bus': (BuildContext context) => const HomeBus(),
    'home_map': (BuildContext context) => const HomeMap(),
    'tour_map': (BuildContext context) => const TourMap(),
    'navigation': (BuildContext context) => const NavigationPage(), 
    'mapa': (BuildContext context) => const MapaPage(), 
  };
}
