import 'package:bus_client/src/buses/home_bus.dart';
import 'package:bus_client/src/login.dart';
import 'package:bus_client/src/maps/home_map.dart';
import 'package:flutter/material.dart';
import 'navigation/navigation_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    HomePublicidad(),
    Login(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            backgroundColor:Colors.red,
            label: 'Publicidad',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            backgroundColor:Colors.red,
            label: 'Login',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
