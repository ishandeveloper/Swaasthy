/*
  This widget wraps up all different screen containers, with a bottom 
  navigation bar and manages different routes of the screen
*/

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/received_notification.dart';
import '../models/user.dart';
import 'indicator.dart';
import '../services/apimedic_service.dart';
import '../services/index.dart';
import '../services/router/routes.dart';
import '../services/user_services.dart';
import '../shared_widgets/index.dart';
import '../utils/index.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import './index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// int currentIndex = 0; // Current Screen Index

class ScreensWrapper extends StatefulWidget {
  final bool refresh;

  final int userType = user.type;

  ScreensWrapper({this.refresh = false, Key key}) : super(key: key);

  @override
  _ScreensWrapperState createState() => _ScreensWrapperState();
}

class _ScreensWrapperState extends State<ScreensWrapper> {
  /*================ VARIABLES =====================*/

  PageController _pageController; // Navigation Screen Controller

  bool leftToRight = true; // Boolean to check for type of transition

  String _token;
  Stream<String> _tokenStream;
  int _messageCount = 0;

/* ================ Initialize ===================== */
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    getUserIp();
    //TODO: Save in sharedpref for 2 hrs
    ApiMedicService().auth();

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
      final notification = message.notification;
      final android = message.notification?.android;

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
                icon: 'app_icon',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('A new onMessageOpenedApp event was published!');
      UserService().increaseUserHeartPoints(50);
      Navigator.pushNamed(context, CodeRedRoutes.home);
    });

    // Send FCM Request
    sendPushMessage();
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

  void getUserIp() async {
    final response =
        await http.get(Uri.parse('https://worldtimeapi.org/api/ip'));
    if (response.statusCode == 200) {
      user = User(
          points: user.points,
          age: user.age,
          email: user.email,
          gender: user.gender,
          username: user.username,
          ip: json.decode(response.body)['client_ip'],
          type: user.type,
          uid: user.uid);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(user.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    final _service = Provider.of<ScreensWrapperService>(context, listen: true);

    final currentIndex = _service.getIndex();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_pageController.page.round() != currentIndex)
        _pageController.jumpToPage(currentIndex);
    });

    return Phoenix(
      child: Scaffold(
        body: Container(
            color: CodeRedColors.base,
            child: SafeArea(
                child: Scaffold(
                    bottomNavigationBar: isKeyboardVisible(context)
                        ? null
                        : NavBar(
                            currentIndex: currentIndex,
                            onChange: (e) => _navbarChangeHandler(_service, e)),
                    body: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (e) => _pageChangeHandler(_service, e),
                        children: [
                          TransitionWrapper(
                              ltr: leftToRight, child: const HomeScreen()),
                          TransitionWrapper(
                              ltr: leftToRight, child: StatsScreen()),
                          TransitionWrapper(
                              ltr: leftToRight,
                              child: ForumsScreen(refresh: widget.refresh)),
                          TransitionWrapper(
                              ltr: leftToRight,
                              child: ConsultDoctor(
                                userType: widget.userType,
                              )),
                        ])))),
      ),
    );
  }

  void _navbarChangeHandler(ScreensWrapperService svc, index) {
    _pageController.jumpToPage(index);
    svc.changeIndex(index);
    // setState(() => currentIndex = index);
  }

  // Handles PageView Tab Change
  void _pageChangeHandler(ScreensWrapperService svc, index) {
    setState(() {
      leftToRight = index < svc.getIndex();
    });

    svc.changeIndex(index);
  }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   super.dispose();
  // }
}

class DummyScreen extends StatelessWidget {
  final String title;

  const DummyScreen({@required this.title, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(title)));
  }
}
