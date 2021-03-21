import 'package:flutter/material.dart';

import 'signup.dart';

class AgePage extends StatefulWidget {
  final PageController pageController;
  AgePage({this.pageController});
  @override
  _AgePageState createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  TextEditingController ageController = TextEditingController();
  bool active = false;
  String error;

  @override
  void initState() {
    super.initState();

    ageController.addListener(() {
      if (ageController.text.length > 0) {
        active = true;
      } else {
        active = false;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter Your Age, $name",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey[300])),
              child: TextField(
                controller: ageController,
                style: TextStyle(
                  fontSize: 18,
                ),
                onChanged: (value) {
                  setState(() {
                    error = '';
                    age = value;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(10),
                    isDense: true),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              error ?? '',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 50,
        decoration: BoxDecoration(
            color: active ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(10)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: active
                ? () {
                    if (age.isNotEmpty) {
                      if (widget.pageController.hasClients) {
                        widget.pageController.nextPage(
                            duration: Duration(milliseconds: 250),
                            curve: Curves.ease);
                      }
                    } else {
                      error = "Enter Valid Email";
                      setState(() {});
                    }
                  }
                : () {},
            child: Center(
              child: Text(
                'NEXT',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
