import 'dart:async';

import '../../../../models/index.dart';
import '../../../../services/index.dart';
import '../../../../utils/index.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../index.dart';

class HomeCardActions extends StatelessWidget {
  const HomeCardActions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _service = Provider.of<ScreensWrapperService>(context, listen: false);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const HalfWidthHomeCard(
                background: CodeRedColors.medicineCard,
                header: 'Reminder',
                subText: 'Medicine',
                imagePath: 'assets/images/medicine-reminder.png',
                path: '/reminder'),
            HalfWidthHomeCard(
              background: Colors.white,
              header: 'Patients',
              subText: 'Connect with',
              imagePath: 'assets/images/connect.png',
              onTap: () => _service.changeIndex(2),
            )
          ],
        ),
        const SizedBox(height: 10),
        FullWidthHomeCard(
          subText: 'Consult a',
          header: 'Doctor',
          onTap: () => _service.changeIndex(3),
          imagePath: 'assets/images/doctor.png',
          background: Colors.white,
        ),
        const MapWidget()
      ],
    );
  }
}

class MapWidget extends StatefulWidget {
  const MapWidget({Key key}) : super(key: key);
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  static const CameraPosition _initialMapPosition = CameraPosition(
    target: LatLng(30.51571185, 76.65919461679499),
    zoom: 14.4746,
  );

  final Completer<GoogleMapController> _mapsController = Completer();

  GoogleMapController _activeMapsController;

  CameraPosition _mapPosition;

  Position _userGeoPosition;

  BitmapDescriptor myLocationPin;

  BitmapDescriptor ambulancePin;

  List<Ambulance> _ambulancesList;

  void locateUserPosition() async {
    final _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest);
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

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void getAmbulanceLocations() async {
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/emergency');
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (_ambulancesList == null)
              const Text('Looking for ambulances in your area..',
                  style: TextStyle(fontSize: 18)),
            if (_ambulancesList?.length == 1)
              const Text('1 ambulance in your area',
                  style: TextStyle(fontSize: 18)),
            if (_ambulancesList != null && _ambulancesList.length > 1)
              Text('${_ambulancesList?.length} ambulances in your area',
                  style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Container(
                width: getContextWidth(context) * 1,
                height: 150,
                decoration: BoxDecoration(boxShadow: const [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 6,
                      offset: Offset(0, 2))
                ], borderRadius: BorderRadius.circular(8), color: Colors.white),
                child: GoogleMap(
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  buildingsEnabled: false,
                  trafficEnabled: false,
                  minMaxZoomPreference: const MinMaxZoomPreference(12, 16),
                  mapToolbarEnabled: false,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: _initialMapPosition,
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
                )),
          ],
        ),
      ),
    );
  }
}
