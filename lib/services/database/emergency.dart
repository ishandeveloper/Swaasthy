import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/emergency/ambulance.dart';

class EmergencyHelper {
  static Future<List<Ambulance>> getAmbulance({String city}) async {
    if (city != null)
      return  FirebaseFirestore.instance
          .collection('ambulances')
          .where('city', isEqualTo: city)
          .get()
          .then((e) {
        final _ = <Ambulance>[];
        e.docs.forEach((doc) {
          _.add(Ambulance.getModel(doc.data()));
        });
        return _;
      });

    return  FirebaseFirestore.instance
        .collection('ambulances')
        .get()
        .then((e) {
      final _ = <Ambulance>[];
      e.docs.forEach((doc) {
        _.add(Ambulance.getModel(doc.data()));
      });
      return _;
    });
  }
}
