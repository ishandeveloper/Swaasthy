import 'dart:async';

import 'package:codered/models/index.dart';
import 'package:codered/services/index.dart';
import 'package:codered/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../index.dart';

class HomeCardActions extends StatelessWidget {
  const HomeCardActions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreensWrapperService _service =
        Provider.of<ScreensWrapperService>(context, listen: false);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HalfWidthHomeCard(
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
        SizedBox(height: 10),
        FullWidthHomeCard(
          subText: 'Consult a',
          header: 'Doctor',
          onTap: () => _service.changeIndex(3),
          imagePath: 'assets/images/doctor.png',
          background: Colors.white,
        ),
        MapWidget()
      ],
    );
  }
}

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  static final CameraPosition _initialMapPosition = CameraPosition(
    target: LatLng(30.51571185, 76.65919461679499),
    zoom: 14.4746,
  );

  Completer<GoogleMapController> _mapsController = Completer();

  late GoogleMapController _activeMapsController;

  CameraPosition? _mapPosition;

  late Position _userGeoPosition;

  late BitmapDescriptor myLocationPin;

  late BitmapDescriptor ambulancePin;

  List<Ambulance>? _ambulancesList;

  void locateUserPosition() async {
    Position _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest);
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

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void getAmbulanceLocations() async {
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/emergency');
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            if (_ambulancesList == null)
              Text("Looking for ambulances in your area..",
                  style: TextStyle(fontSize: 18)),
            if (_ambulancesList?.length == 1)
              Text("1 ambulance in your area", style: TextStyle(fontSize: 18)),
            if (_ambulancesList != null && _ambulancesList!.length > 1)
              Text("${_ambulancesList?.length} ambulances in your area",
                  style: TextStyle(fontSize: 18)),
            SizedBox(height: 4),
            Container(
                width: getContextWidth(context) * 1,
                height: 150,
                decoration: BoxDecoration(boxShadow: [
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
                  minMaxZoomPreference: MinMaxZoomPreference(12, 16),
                  mapToolbarEnabled: false,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: _initialMapPosition,
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
                )),
          ],
        ),
      ),
    );
  }
}
