import 'package:codered/models/diagnosis.dart';
import 'package:flutter/material.dart';

class DiagnosisResultNotifier with ChangeNotifier {
  DiagnosisResult diagnosisResult;
  onNewDiagnosis(List<dynamic> parsedJson) {
    diagnosisResult = DiagnosisResult.fromJSON(parsedJson);
    notifyListeners();
  }
}
