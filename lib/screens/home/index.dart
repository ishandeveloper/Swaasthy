import 'dart:convert';
import 'package:codered/models/received_notification.dart';
import 'package:codered/services/router/routes.dart';
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
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  String _token;
  Stream<String> _tokenStream;
  int _messageCount = 0;

  @override
  void initState() {
    super.initState();

    _configureDidReceiveLocalNotificationSubject();

    FirebaseMessaging.instance.getToken().then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        Navigator.pushNamed(context, CodeRedRoutes.home);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(context, CodeRedRoutes.home);
    });
  }

  void setToken(String token) {
    print('FCM Token: $token');
    setState(() {
      _token = token;
    });
  }

  Future<void> sendPushMessage() async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      print('key=${CodeRedKeys.fcmServerKey}');
      await http.post(
        //TODO: Send Request
        Uri.parse('https://fcm.googleapis.com/fcm/send'),

        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': CodeRedKeys.fcmServerKey
        },
        body: constructFCMPayload(_token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  String constructFCMPayload(String token) {
    _messageCount++;
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': _messageCount.toString(),
      },
      'notification': {
        'title': 'Hello Codered!',
        'body': 'This notification (#$_messageCount) was created via FCM!',
      },
    });
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.pushNamed(context, CodeRedRoutes.home);
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        key: drawerKey,
        floatingActionButton: FloatingActionButton(
          backgroundColor: CodeRedColors.primary,
          onPressed: () async {
            await sendPushMessage();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
