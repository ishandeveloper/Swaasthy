import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codered/models/user.dart';
import 'package:codered/screens/indicator.dart';
import 'package:flutter/foundation.dart';

class UserService with ChangeNotifier {
  String name, age, gender = '';
  int accountType, points;
  bool active = false;

  putName(String val) {
    name = val;
    notifyListeners();
  }

  putAge(String val) {
    age = val;
    notifyListeners();
  }

  putGender(String val) {
    gender = val;
    notifyListeners();
  }

  putType(int val) {
    accountType = val;
    notifyListeners();
  }

  updateStatus(bool status) {
    active = status;
    notifyListeners();
  }

  increaseUserHeartPoints(int pnts) async {
    points = user.points;
    points += pnts;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'points': pnts}).then((value) => user = User(
            uid: user.uid,
            username: user.username,
            points: points,
            age: user.age,
            gender: user.gender,
            email: user.email,
            type: user.type));
  }
}
