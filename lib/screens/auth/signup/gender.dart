import 'package:codered/services/signup_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenderPage extends StatefulWidget {
  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  String error;
  bool active = false;

  List<Gender> genderList = <Gender>[
    Gender(name: 'MALE', imgrURL: '', index: 0),
    Gender(name: 'FEMALE', imgrURL: '', index: 1)
  ];

  int _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = Provider.of<SignUpService>(context, listen: false)
            .gender
            .startsWith('m')
        ? 0
        : 1;
    Provider.of<SignUpService>(context, listen: false).updateStatus(false);
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedGender != null)
      Provider.of<SignUpService>(context, listen: false).updateStatus(true);
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Your Password",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
              margin: const EdgeInsets.only(top: 30),
              width: double.infinity,
              child: Row(
                children: genderList.map((e) => genderCard(gender: e)).toList(),
              )),
        ],
      ),
    ));
  }

  Widget genderCard({Gender gender}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
              color: _selectedGender == gender.index
                  ? Colors.blueGrey
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    offset: Offset(1, 2),
                    color: Colors.grey[300],
                    blurRadius: 10)
              ]),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedGender = gender.index;
                });
                Provider.of<SignUpService>(context, listen: false)
                    .putGender(gender.name.toLowerCase());
                Provider.of<SignUpService>(context, listen: false)
                    .updateStatus(true);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.image,
                      size: 35,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      gender.name,
                      style: TextStyle(
                          fontSize: 18,
                          color: _selectedGender == gender.index
                              ? Colors.white
                              : Colors.black),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Gender {
  final String name;
  final String imgrURL;
  final int index;
  Gender({this.name, this.imgrURL, this.index});
}
