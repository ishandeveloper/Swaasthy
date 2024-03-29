import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codered/models/emergency/ambulance.dart';

class EmergencyHelper {
  static Future<List<Ambulance>> getAmbulance({String city}) async {
    if (city != null)
      return await FirebaseFirestore.instance
          .collection('ambulances')
          .where('city', isEqualTo: city)
          .get()
          .then((e) {
        List<Ambulance> _ = [];
        e.docs.forEach((doc) {
          _.add(Ambulance.getModel(doc.data()));
        });
        return _;
      });

    return await FirebaseFirestore.instance
        .collection('ambulances')
        .get()
        .then((e) {
      List<Ambulance> _ = [];
      e.docs.forEach((doc) {
        _.add(Ambulance.getModel(doc.data()));
      });
      return _;
    });
  }
}
