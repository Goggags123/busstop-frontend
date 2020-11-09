import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int _currentIndex;
  final _key = GlobalKey();
  BottomNavBar(this._currentIndex);
  void _onItemTapped(BuildContext context, int index) {
    if (index != _currentIndex) {
      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/location');
          break;
        case 1:
          Navigator.pushNamed(context, '/map');
          break;
        case 2:
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      key: _key,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.location_pin),
          label: 'Location',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Account',
        ),
      ],
      onTap: (index) => _onItemTapped(context, index),
      currentIndex: _currentIndex,
    );
  }
}
