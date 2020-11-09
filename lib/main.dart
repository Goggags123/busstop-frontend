import 'dart:async';

import 'package:busstop/bottom-navigation-bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import './map.dart';
import './location.dart';

void main() {
  runApp(MyApp());
}

/// Example Flutter Application demonstrating the functionality of the
/// Permission Handler plugin.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State {
  Location _location = new Location();
  LocationData _currentLocation;
  StreamSubscription<LocationData> _locationSubscription;
  CameraPosition _initialPosition;
  int _currentIndex = 1;
  bool isLoading = true;

  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    final status = await _location.requestPermission();
    if (status == PermissionStatus.granted) {
      _locationSubscription =
          _location.onLocationChanged.listen((LocationData result) {
        setState(() {
          _currentLocation = result;
        });
      });
      LocationData start = await _location.getLocation();
      setState(() {
        isLoading = false;
        _initialPosition = CameraPosition(
          target: LatLng(start.latitude, start.longitude),
          zoom: 10,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          bottomNavigationBar: BottomNavBar(_currentIndex),
          appBar: AppBar(
            title: Text('Map'),
          ),
          body: (!isLoading) ? Map(_initialPosition) : null,
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/map': (BuildContext context) => MyApp(),
        '/location': (BuildContext context) => Result(
              currentLocation: _currentLocation,
            ),
      },
    );
  }
}
