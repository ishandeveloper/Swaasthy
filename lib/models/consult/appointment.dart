import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final List<AppointmentItem> appointments;

  Appointment({this.appointments});

  factory Appointment.getModel(DocumentSnapshot data) {
    final _ = <AppointmentItem>[];

    data['appointments']?.forEach((e) {
      _.add(AppointmentItem.getModel(e));
    });

    return Appointment(appointments: _);
  }
}

class AppointmentItem {
  final String id;
  final String doctorID;
  final String doctorImage;
  final String doctorName;
  final List<Prescription> prescription;
  final Timestamp timestamp;

  AppointmentItem({
    this.doctorID,
    this.id,
    this.prescription,
    this.timestamp,
    this.doctorImage,
    this.doctorName,
  });

  factory AppointmentItem.getModel(Map<String, dynamic> data) {
    final _ = <Prescription>[];

    data['prescription']?.forEach((e) {
      _.add(Prescription(
          medicine: e['name'],
          dailyDosage: e['daily'],
          courseDays: e['period']));
    });

    return AppointmentItem(
      doctorID: data['doctorID'] as String,
      id: data['id'] as String,
      prescription: _,
      doctorImage: data['doctor_image'] as String,
      doctorName: data['doctor_name'] as String,
      timestamp: data['timestamp'] as Timestamp,
    );
  }
}

class Prescription {
  final String medicine;
  final int dailyDosage;
  final int courseDays;

  Prescription({this.courseDays, this.dailyDosage, this.medicine});
}
