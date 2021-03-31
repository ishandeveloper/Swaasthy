import 'dart:convert';
import 'package:codered/models/received_notification.dart';
import 'package:codered/services/router/routes.dart';
import 'package:codered/services/user_services.dart';
import 'package:codered/utils/constants/colors.dart';
import 'package:codered/utils/constants/keys.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:codered/main.dart';
import '../drawer.dart';
import 'package:http/http.dart' as http;
import 'local_widgets/index.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        key: drawerKey,
        floatingActionButton: FloatingActionButton(
          backgroundColor: CodeRedColors.primary,
          onPressed: () {
            Navigator.pushNamed(context, '/emergency');
          },
          child: Transform.translate(
            offset: Offset(25, 0),
            child: Transform(
                transform: Matrix4.rotationY((-2) * 3.142857142857143 / 2),
                child: Icon(FontAwesome.ambulance)),
          ),
        ),
        drawer: HomeScreenDrawer(),
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 72),
            child: HomeAppBar(
              drawerKey: drawerKey,
            )),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: ListView(
              children: [
                HomeGreetings(),
                SizedBox(height: 20),
                HomeSearch(),
                SizedBox(height: 20),
                HomeCardActions()
              ],
            )),
      ),
    );
  }
}
