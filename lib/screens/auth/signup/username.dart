import 'package:flutter/material.dart';

import 'signup.dart';

class UserNamePage extends StatefulWidget {
  final PageController pageController;
  UserNamePage({
    this.pageController,
  });
  @override
  _UserNamePageState createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  TextEditingController nameController = TextEditingController();
  bool active = false;

  @override
  void initState() {
    super.initState();

    nameController.addListener(() {
      if (nameController.text.length > 0) {
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
              "Create Your User Name",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey[300])),
              child: TextFormField(
                controller: nameController,
                style: TextStyle(
                  fontSize: 18,
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator: (value) {
                  if (value.isEmpty) return "Enter a valid username";
                  return null;
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(10),
                    isDense: true),
              ),
            )
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
                    if (widget.pageController.hasClients) {
                      widget.pageController.nextPage(
                          duration: Duration(milliseconds: 250),
                          curve: Curves.ease);
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
