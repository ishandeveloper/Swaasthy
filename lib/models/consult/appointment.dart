import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  Appointment({this.appointments});

  factory Appointment.getModel(DocumentSnapshot<Map<String, dynamic>> data) {
    List<AppointmentItem> _ = <AppointmentItem>[];

    data['appointments']?.forEach((Map<String, dynamic> e) {
      _.add(AppointmentItem.getModel(e));
    });

    return Appointment(appointments: _);
  }
  final List<AppointmentItem>? appointments;
}

class AppointmentItem {
  AppointmentItem({
    this.doctorID,
    this.id,
    this.prescription,
    this.timestamp,
    this.doctorImage,
    this.doctorName,
  });

  factory AppointmentItem.getModel(Map<String, dynamic> data) {
    List<Prescription> _ = <Prescription>[];

    data['prescription']?.forEach((Map<String, dynamic> e) {
      _.add(Prescription(
          medicine: e['name'],
          dailyDosage: e['daily'],
          courseDays: e['period']));
    });

    return AppointmentItem(
      doctorID: data['doctorID'] as String?,
      id: data['id'] as String?,
      prescription: _,
      doctorImage: data['doctor_image'] as String?,
      doctorName: data['doctor_name'] as String?,
      timestamp: data['timestamp'] as Timestamp?,
    );
  }

  final String? id;
  final String? doctorID;
  final String? doctorImage;
  final String? doctorName;
  final List<Prescription>? prescription;
  final Timestamp? timestamp;
}

class Prescription {
  Prescription({this.courseDays, this.dailyDosage, this.medicine});

  final String? medicine;
  final int? dailyDosage;
  final int? courseDays;
}
