import 'package:flutter/material.dart';

class PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  TextEditingController passwordController = TextEditingController();
  String password, error;
  bool active = false;
  static Pattern patternPassword = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regexPassword = new RegExp(patternPassword);

  @override
  void initState() {
    super.initState();

    passwordController.addListener(() {
      if (passwordController.text.length > 0) {
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
              "Enter Your Password",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey[300])),
              child: TextField(
                controller: passwordController,
                style: TextStyle(
                  fontSize: 18,
                ),
                onChanged: (value) {
                  setState(() {
                    error = '';
                    password = value;
                  });
                },
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
                    if (regexPassword.hasMatch(password.trim())) {
                    } else {
                      error = "Enter Valid Password";
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