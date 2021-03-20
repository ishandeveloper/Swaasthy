import 'package:codered/services/auth_service.dart';
import 'package:codered/services/router/routes.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            var result = Authentication.signInWithGoogle();
            if (result != null)
              Navigator.pushNamedAndRemoveUntil(
                  context, CodeRedRoutes.home, (route) => false);
          },
          child: Text(
            'Google Auth',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
