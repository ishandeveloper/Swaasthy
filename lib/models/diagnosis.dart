class DiagnosisResult {
  List<Diagnosis> diagnosisResult = [];

  DiagnosisResult({this.diagnosisResult});

  factory DiagnosisResult.fromJSON(List<dynamic> parsedJson) {
    DiagnosisResult diagnosisResult = DiagnosisResult(
        diagnosisResult: parsedJson.map((e) => Diagnosis.fromJSON(e)).toList());
    print("Checking " + diagnosisResult.diagnosisResult[1].name);
    return diagnosisResult;
  }
}

class Diagnosis {
  final num accuracy;
  final String name;
  final String specialist;
  final String alsoKnownAs;

  Diagnosis({this.accuracy, this.name, this.specialist, this.alsoKnownAs});

  factory Diagnosis.fromJSON(Map<dynamic, dynamic> parsedJson) {
    return Diagnosis(
      name: parsedJson['Issue']['Name'],
      accuracy: parsedJson["Issue"]['Accuracy'],
      alsoKnownAs: parsedJson['Issue']['ProfName'],
      specialist: parsedJson['Specialisation'][1]['Name'],
    );
  }
}
