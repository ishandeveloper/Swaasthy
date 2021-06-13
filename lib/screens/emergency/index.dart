import 'dart:async';

import '../../models/index.dart';
import '../../services/database/emergency.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'local_widgets/index.dart';

Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({Key key}) : super(key: key);

  // Google Maps Controller
  static const CameraPosition _initialMapPosition = CameraPosition(
    target: LatLng(30.51571185, 76.65919461679499),
    zoom: 14.4746,
  );

  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final Completer<GoogleMapController> _mapsController = Completer();

  GoogleMapController _activeMapsController;

  CameraPosition _mapPosition;

  Position _userGeoPosition;

  BitmapDescriptor myLocationPin;

  BitmapDescriptor ambulancePin;

  List<Ambulance> _ambulancesList;

  void locateUserPosition() async {
    final _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _userGeoPosition = _position;

    final _latLongPosition =
        LatLng(_userGeoPosition.latitude, _userGeoPosition.longitude);

    _mapPosition = CameraPosition(target: _latLongPosition, zoom: 14.4746);
    _activeMapsController
        .animateCamera(CameraUpdate.newCameraPosition(_mapPosition));

    final marker = Marker(
      markerId: const MarkerId('user_location'),
      draggable: true,
      position: _mapPosition
          .target, //With this parameter you automatically obtain latitude and longitude
      infoWindow: const InfoWindow(
        title: 'Current Location',
      ),
      icon: myLocationPin,
    );

    setState(() {
      _mapPosition = _mapPosition;
      markers[const MarkerId('user_location')] = marker;
    });
  }

  void getAmbulanceLocations() async {
    // Perform API CALL or something
    // var _locations = [
    //   LatLng(31.35640071369591, 75.58713275939226),
    //   LatLng(31.35047652728435, 75.58832164853811)
    // ];

    final _temp = await EmergencyHelper.getAmbulance();
    setState(() => _ambulancesList = _temp);

    for (var i = 0; i < _temp.length; i++) {
      final marker = Marker(
        markerId: MarkerId(i.toString()),
        draggable: true,
        position: _temp[i].coordinates,
        icon: ambulancePin,
      );

      markers[MarkerId(i.toString())] = marker;
    }
  }

  @override
  void initState() {
    super.initState();

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(64, 64)),
            'assets/icons/pin-2-128.png')
        .then((d) {
      myLocationPin = d;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(64, 64)),
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
                minMaxZoomPreference: const MinMaxZoomPreference(12, 16),
                mapToolbarEnabled: false,
                myLocationButtonEnabled: true,
                initialCameraPosition: EmergencyScreen._initialMapPosition,
                onCameraMove: (e) {
                  final marker = Marker(
                    markerId: const MarkerId('user_location'),
                    draggable: true,
                    position: e
                        .target, //With this parameter you automatically obtain latitude and longitude
                    infoWindow: const InfoWindow(
                      title: 'Your Location',
                      snippet: 'Drag or move to change',
                    ),
                    icon: myLocationPin,
                  );

                  setState(() {
                    _mapPosition = e;
                    markers[const MarkerId('user_location')] = marker;
                  });
                },
                markers: Set<Marker>.of(markers.values),
                onMapCreated: (GoogleMapController _controller) {
                  _mapsController.complete(_controller);
                  _activeMapsController = _controller;

                  locateUserPosition();

                  getAmbulanceLocations();
                },
                padding: const EdgeInsets.only(bottom: 300),
              ),
              EmergencyConfirmationSheet(
                  onConfirm: () {},
                  ambulance:
                      _ambulancesList != null ? _ambulancesList[0] : null),
            ],
          ),
        ),
      ),
    );
  }
}
