import 'package:flutter/cupertino.dart';

class MedicineReminderData {
  final String title;
  final DateTime time;
  final String description;

  MedicineReminderData({this.title, this.time, this.description});
}

class MedicineReminderService with ChangeNotifier {
  List<MedicineReminderData> medicineReminderList =
      <MedicineReminderData>[
    MedicineReminderData(
      time: DateTime.now(),
      title: 'Diabetes Tablets',
      description: 'Take Starvog M 0.3 tablets along with water',
    ),
  ];

  updateList(MedicineReminderData medicineReminderData) {
    medicineReminderList.add(medicineReminderData);
    notifyListeners();
  }
}
