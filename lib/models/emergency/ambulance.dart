import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Ambulance {
  final String city;
  final String assignID;
  final LatLng coordinates;
  final bool isAvailable;
  final String vehicleNumber;

  Ambulance({
    this.assignID,
    this.city,
    this.coordinates,
    this.isAvailable,
    this.vehicleNumber,
  });

  factory Ambulance.getModel(Map<String, dynamic> data) {
    GeoPoint _ = data['coordinates'] as GeoPoint;

    return Ambulance(
      assignID: data['assigned_to'],
      city: data['city'],
      coordinates: LatLng(_.latitude, _.longitude),
      vehicleNumber: data['vehicle_number'],
      isAvailable: data['is_available'],
    );
  }
}
