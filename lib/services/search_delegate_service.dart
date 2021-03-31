import 'package:codered/screens/diagnosis.dart';
import 'package:codered/services/apimedic_service.dart';
import 'package:codered/utils/constants/symptoms.dart';
import 'package:flutter/material.dart';

class SearchBarDelegateService extends SearchDelegate<Symptoms> {
  List<Symptoms> recentSuggest;
  List<Symptoms> symptomsList;
  List<int> symptomsId = [];
  SearchBarDelegateService() {
    symptomsList = symptoms;
    recentSuggest = [
      Symptoms(
        ID: 187,
        Name: "Wound",
      ),
      Symptoms(
        ID: 22,
        Name: "Weight loss",
      )
    ];
  }
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = "")];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return DiagnosisReport(
      symptoms: symptomsId,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSuggest
        : symptomsList
            .where((input) =>
                input.Name.toUpperCase().startsWith(query.toUpperCase()))
            .toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) => ListTile(
              onTap: () async {
                query = suggestionList[index].Name;
                symptomsId.add(suggestionList[index].ID);
                showResults(context);
                recentSuggest.insert(0, suggestionList[index]);
              },
              title: RichText(
                  text: TextSpan(
                      text:
                          suggestionList[index].Name.substring(0, query.length),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                    TextSpan(
                        text:
                            suggestionList[index].Name.substring(query.length),
                        style: TextStyle(color: Colors.grey))
                  ])),
            ));
  }
}
