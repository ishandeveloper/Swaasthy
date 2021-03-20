import 'package:codered/services/auth_service.dart';
import 'package:flutter/material.dart';

class ScreenDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Authentication.signOutFromGoogle();
              },
              child: Text('Sign Out'))
        ],
      ),
    );
  }
}
