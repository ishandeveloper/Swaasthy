import 'package:flutter/foundation.dart';

class SignUpService with ChangeNotifier {
  String name, age, gender='';
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

  updateStatus(bool status) {
    active = status;
    notifyListeners();
  }
}
