import 'package:codered/screens/indicator.dart';
import 'package:codered/services/auth_service.dart';
import 'package:codered/utils/constants/colors.dart';
import 'package:flutter/material.dart';

import '../services/router/routes.dart';

class HomeScreenDrawer extends StatefulWidget {
  @override
  _HomeScreenDrawerState createState() => _HomeScreenDrawerState();
}

class _HomeScreenDrawerState extends State<HomeScreenDrawer> {
  bool isAnonyous = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                ),
                Flexible(
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 8),
                    title: Text(
                      user.username,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(user.email,
                    style: TextStyle(fontSize: 13),),
                  ),
                )
              ],
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  CodeRedColors.primary,
                  CodeRedColors.primary.withOpacity(0.4)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, size: 30, color: Colors.white),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '28 Heart Points',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              )),
          ListTile(
            dense: true,
            horizontalTitleGap: 0,
            onTap: () async {
              await Authentication.signOutFromGoogle().then((value) =>
                  Navigator.pushNamedAndRemoveUntil(
                      context, CodeRedRoutes.login, (route) => false));
            },
            leading: Icon(Icons.person_outline),
            title: Text('Anonymous Mode'),
            subtitle: Text('Hides your identity on forums'),
            trailing: Switch(
                value: isAnonyous,
                onChanged: (val) {
                  isAnonyous = val;
                  setState(() {});
                }),
          ),
          ListTile(
            dense: true,
            horizontalTitleGap: 0,
            onTap: () async {
              await Authentication.signOutFromGoogle().then((value) =>
                  Navigator.pushNamedAndRemoveUntil(
                      context, CodeRedRoutes.login, (route) => false));
            },
            leading: Icon(Icons.login_outlined),
            title: Text('Log Out'),
            subtitle: Text('from your current google account'),
          )
        ],
      ),
    );
  }
}
