import 'package:codered/services/signup_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserNamePage extends StatefulWidget {
  @override
  _UserNamePageState createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  TextEditingController nameController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
        text: Provider.of<SignUpService>(context, listen: false).name ?? '');

    Provider.of<SignUpService>(context, listen: false).updateStatus(false);

    nameController.addListener(() {
      if (nameController.text.length > 0) {
        Provider.of<SignUpService>(context, listen: false).updateStatus(true);
      } else {
        Provider.of<SignUpService>(context, listen: false).updateStatus(false);
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
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
            child: TextField(
              controller: nameController,
              style: TextStyle(
                fontSize: 18,
              ),
              onChanged: (value) {
                setState(() {
                  Provider.of<SignUpService>(context, listen: false)
                      .putName(value);
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(10),
                  isDense: true),
            ),
          )
        ],
      ),
    ));
  }
}
