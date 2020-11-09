import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class Map extends StatelessWidget {
  final CameraPosition _initialPosition;
  final Completer<GoogleMapController> _controller = Completer();
  Map(this._initialPosition);
  @override
  Widget build(BuildContext context) {
    return (_initialPosition!=null)?Container(
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    ):null;
  }
}
