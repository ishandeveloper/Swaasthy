import 'package:codered/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../services/router/routes.dart';

class HomeScreenDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                await Authentication.signOutFromGoogle().then((value) =>
                    Navigator.pushNamedAndRemoveUntil(
                        context, CodeRedRoutes.login, (route) => false));
              },
              child: Text('Sign Out'))
        ],
      ),
    );
  }
}
