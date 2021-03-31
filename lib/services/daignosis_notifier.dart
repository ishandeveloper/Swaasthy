import 'package:codered/models/diagnosis.dart';
import 'package:flutter/material.dart';

class DiagnosisResultNotifier with ChangeNotifier {
  DiagnosisResult diagnosisResult;
  onNewDiagnosis(List<dynamic> parsedJson) {
    this.diagnosisResult = DiagnosisResult.fromJSON(parsedJson);
    notifyListeners();
    print('diagnosisResult: ' + diagnosisResult.diagnosisResult.toString());
  }
}
