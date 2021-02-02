import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'local_widgets/index.dart';

class EmergencyScreen extends StatelessWidget {
  // Google Maps Controller
  Completer<GoogleMapController> _mapsController = Completer();

  // This will be used to change markers i.e. ambulances, path etc.
  GoogleMapController _activeMapsController;
  // Initial Position Of The Map
  static final CameraPosition _initialMapPosition = CameraPosition(
    target: LatLng(30.51571185, 76.65919461679499),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _initialMapPosition,
            onMapCreated: (GoogleMapController _controller) {
              _mapsController.complete(_controller);
              _activeMapsController = _controller;
            },
          ),
          EmergencyConfirmationSheet()
        ],
      ),
    );
  }
}
