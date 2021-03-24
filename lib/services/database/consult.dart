import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codered/models/index.dart';

class ConsultHelper {
  static Future<List<Doctor>> getHeroDoctors() async {
    return await FirebaseFirestore.instance
        .collection('doctors')
        .where("hero", isEqualTo: true)
        .get()
        .then((e) {
      var _docs = e.docs;
      List<Doctor> _doctors = [];

      _docs.forEach((e) {
        Doctor _ = Doctor.getModel(e.data(), e.id);
        _doctors.add(_);
      });

      return _doctors;
    });
  }

  static Future<List<Doctor>> getTopRatedDoctors() async {
    return await FirebaseFirestore.instance
        .collection('doctors')
        .where("hero", isEqualTo: false)
        .get()
        .then((e) {
      var _docs = e.docs;
      List<Doctor> _doctors = [];

      _docs.forEach((e) {
        Doctor _ = Doctor.getModel(e.data(), e.id);
        _doctors.add(_);
      });

      return _doctors;
    });
  }

  static Future<bool> createAppointment({
    String userID,
    String username,
    String doctorID,
    Timestamp timestamp,
    DateTime date,
  }) async {
    // Calculate Final Timestamp
    Timestamp _timestamp = Timestamp.fromDate(DateTime(date.year, date.month,
        date.day, timestamp.toDate().hour, timestamp.toDate().minute, 0));

    var _appointmentList = [
      {'timestamp': _timestamp, 'doctorID': doctorID, 'prescription': []}
    ];

    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(userID)
        .get()
        .then((_) {
      // IF EXISTS THEN UPDATE DOCUMENT
      if (_.exists)
        _.reference
            .update({'appointments': FieldValue.arrayUnion(_appointmentList)});

      // ELSE SET THE DOCUMENT VALUE
      else
        _.reference
            .set({'patient_name': username, 'appointments': _appointmentList});
    });

    return true;
  }
}
