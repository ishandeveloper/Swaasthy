import 'dart:async';

import 'package:codered/models/index.dart';
import 'package:codered/services/database/emergency.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'local_widgets/index.dart';

Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

class EmergencyScreen extends StatefulWidget {
  // Google Maps Controller
  static final CameraPosition _initialMapPosition = CameraPosition(
    target: LatLng(30.51571185, 76.65919461679499),
    zoom: 14.4746,
  );

  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  Completer<GoogleMapController> _mapsController = Completer();

  late GoogleMapController _activeMapsController;

  CameraPosition? _mapPosition;

  late Position _userGeoPosition;

  late BitmapDescriptor myLocationPin;

  late BitmapDescriptor ambulancePin;

  List<Ambulance>? _ambulancesList;

  void locateUserPosition() async {
    Position _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _userGeoPosition = _position;

    LatLng _latLongPosition =
        LatLng(_userGeoPosition.latitude, _userGeoPosition.longitude);

    _mapPosition = CameraPosition(target: _latLongPosition, zoom: 14.4746);
    _activeMapsController
        .animateCamera(CameraUpdate.newCameraPosition(_mapPosition!));

    Marker marker = Marker(
      markerId: MarkerId('user_location'),
      draggable: true,
      position: _mapPosition!
          .target, //With this parameter you automatically obtain latitude and longitude
      infoWindow: InfoWindow(
        title: "Current Location",
      ),
      icon: myLocationPin,
    );

    setState(() {
      _mapPosition = _mapPosition;
      markers[MarkerId('user_location')] = marker;
    });
  }

  void getAmbulanceLocations() async {
    // Perform API CALL or something
    // var _locations = [
    //   LatLng(31.35640071369591, 75.58713275939226),
    //   LatLng(31.35047652728435, 75.58832164853811)
    // ];

    List<Ambulance> _temp = await EmergencyHelper.getAmbulance();
    setState(() => _ambulancesList = _temp);

    for (int i = 0; i < _temp.length; i++) {
      Marker marker = Marker(
        markerId: MarkerId(i.toString()),
        draggable: true,
        position: _temp[i].coordinates!,
        icon: ambulancePin,
      );

      markers[MarkerId(i.toString())] = marker;
    }
  }

  @override
  void initState() {
    super.initState();

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(64, 64)),
            'assets/icons/pin-2-128.png')
        .then((d) {
      myLocationPin = d;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(64, 64)),
            'assets/icons/ambulance-172.png')
        .then((d) {
      ambulancePin = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                buildingsEnabled: false,
                trafficEnabled: false,
                minMaxZoomPreference: MinMaxZoomPreference(12, 16),
                mapToolbarEnabled: false,
                myLocationButtonEnabled: true,
                initialCameraPosition: EmergencyScreen._initialMapPosition,
                onCameraMove: (e) {
                  Marker marker = Marker(
                    markerId: MarkerId('user_location'),
                    draggable: true,
                    position: e
                        .target, //With this parameter you automatically obtain latitude and longitude
                    infoWindow: InfoWindow(
                      title: "Your Location",
                      snippet: 'Drag or move to change',
                    ),
                    icon: myLocationPin,
                  );

                  setState(() {
                    _mapPosition = e;
                    markers[MarkerId('user_location')] = marker;
                  });
                },
                markers: Set<Marker>.of(markers.values),
                onMapCreated: (GoogleMapController _controller) {
                  _mapsController.complete(_controller);
                  _activeMapsController = _controller;

                  locateUserPosition();

                  getAmbulanceLocations();
                },
                padding: EdgeInsets.only(bottom: 300),
              ),
              EmergencyConfirmationSheet(
                  onConfirm: () {},
                  ambulance:
                      _ambulancesList != null ? _ambulancesList![0] : null),
            ],
          ),
        ),
      ),
    );
  }
}
