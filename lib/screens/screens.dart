/*
  This widget wraps up all different screen containers, with a bottom 
  navigation bar and manages different routes of the screen
*/

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codered/models/user.dart';
import 'package:codered/screens/indicator.dart';
import 'package:codered/services/index.dart';
import 'package:codered/shared_widgets/index.dart';
import 'package:codered/utils/index.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import './index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// int currentIndex = 0; // Current Screen Index

class ScreensWrapper extends StatefulWidget {
  final bool refresh;

  final int userType;

  ScreensWrapper(
      {this.refresh = false, this.userType = 0}); //TODO: ADD USER TYPE

  @override
  _ScreensWrapperState createState() => _ScreensWrapperState();
}

class _ScreensWrapperState extends State<ScreensWrapper> {
  /*================ VARIABLES =====================*/

  PageController _pageController; // Navigation Screen Controller

  bool leftToRight = true; // Boolean to check for type of transition

/* ================ Initialize ===================== */
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    getUserIp();
  }

  getUserIp() async {
    http.Response response =
        await http.get(Uri.parse('https://worldtimeapi.org/api/ip'));
    if (response.statusCode == 200) {
      print("JSON BODY" + json.decode(response.body).toString());

      user = User(
          points: user.points,
          age: user.age,
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
    ScreensWrapperService _service =
        Provider.of<ScreensWrapperService>(context, listen: true);

    int currentIndex = _service.getIndex();

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
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (e) => _pageChangeHandler(_service, e),
                        children: [
                          TransitionWrapper(
                              ltr: leftToRight, child: HomeScreen()),
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

  DummyScreen({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(title)));
  }
}
