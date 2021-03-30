import 'package:codered/models/diagnosis.dart';
import 'package:codered/services/apimedic_service.dart';
import 'package:codered/utils/constants/symptoms.dart';
import '../services/daignosis_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBarDelegateService extends SearchDelegate<Symptoms> {
  List<Symptoms> recentSuggest;
  List<Symptoms> symptomsList;
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
    ;
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
    PageController pageController = PageController();

    Widget pageView(Diagnosis diagnosis) {
      return Column(
        children: [Text(diagnosis.name)],
      );
    }

    return Container(
      child: Consumer<DiagnosisResultNotifier>(builder: (context, dsn, child) {
        //TODO: Check here
        if (dsn.diagnosisResult == null)
          return Center(
            child: CircularProgressIndicator(),
          );
        else
          return Column(
            children: [
              PageView(
                controller: pageController,
                children: dsn.diagnosisResult.diagnosisResult
                    // .sublist(0, 1)
                    .map((e) => pageView(e))
                    .toList(),
              ),
            ],
          );
      }),
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
              onTap: () {
                query = suggestionList[index].Name;
                ApiMedicService().getInfo([suggestionList[index].ID]);
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
    ;
  }
}
