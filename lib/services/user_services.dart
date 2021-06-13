import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../screens/indicator.dart';
import 'package:flutter/foundation.dart';

class UserService with ChangeNotifier {
  String name, age, gender = '';
  int accountType, points;
  bool active = false;

  void putName(String val) {
    name = val;
    notifyListeners();
  }

  void putAge(String val) {
    age = val;
    notifyListeners();
  }

  void putGender(String val) {
    gender = val;
    notifyListeners();
  }

  void putType(int val) {
    accountType = val;
    notifyListeners();
  }

  void updateStatus(bool status) {
    active = status;
    notifyListeners();
  }

  void increaseUserHeartPoints(int pnts) async {
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
