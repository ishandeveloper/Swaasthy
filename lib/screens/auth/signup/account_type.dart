import 'package:codered/services/signup_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountType extends StatefulWidget {
  @override
  _AccountTypeState createState() => _AccountTypeState();
}

class _AccountTypeState extends State<AccountType> {
  int accountType;

  @override
  void initState() {
    super.initState();
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
            "Are you a medical volunteer?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
              margin: const EdgeInsets.only(top: 30),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [chooseAccount('Yes', 1), chooseAccount('No', 0)],
              )),
        ],
      ),
    ));
  }

  Widget chooseAccount(String text, int value) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey[200]),
      child: Row(
        children: [
          Radio(
              value: value,
              groupValue: accountType,
              onChanged: (val) {
                setState(() {
                  accountType = val;
                  Provider.of<SignUpService>(context, listen: false)
                      .putType(val);
                });
              }),
          Text(text),
          SizedBox(width: 4)
        ],
      ),
    );
  }
}
