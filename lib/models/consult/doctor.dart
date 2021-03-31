import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Doctor {
  final String name;
  final String uid;
  final String image;
  final String type;
  final double rating;
  final DoctorDetails details;
  final List<Timestamp> timeslots;

  Doctor({
    @required this.name,
    @required this.uid,
    @required this.image,
    @required this.type,
    @required this.details,
    @required this.rating,
    this.timeslots,
  });

  factory Doctor.getModel(Map<String, dynamic> data, String docID) {
    return Doctor(
        uid: docID,
        name: data['name'] as String,
        rating: data['stars'] as double,
        image: data['image'] as String,
        type: data['type'] as String,
        timeslots: List<Timestamp>.from(data['timeslots']),
        details: DoctorDetails.getModel(data['details']));
  }
}

class DoctorDetails {
  final int patients;
  final int years;
  final int rating;
  final String description;
  final String location;

  DoctorDetails({
    this.description,
    this.patients,
    this.rating,
    this.years,
    this.location,
  });

  factory DoctorDetails.getModel(Map<String, dynamic> data) {
    return DoctorDetails(
        description: data['description'] as String,
        patients: data['patients'] as int,
        rating: data['rating'] as int,
        years: data['years'] as int,
        location: data['location'] as String);
  }
}
