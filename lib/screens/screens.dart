/*
  This widget wraps up all different screen containers, with a bottom 
  navigation bar and manages different routes of the screen
*/

import 'package:codered/shared_widgets/index.dart';
import 'package:codered/utils/index.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import './index.dart';
import 'package:flutter/material.dart';

int currentIndex = 0; // Current Screen Index

class ScreensWrapper extends StatefulWidget {
  final bool refresh;

  ScreensWrapper({this.refresh = false});

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
  }

  @override
  Widget build(BuildContext context) {
    return Phoenix(
      child: Scaffold(
        key: CodeRedKeys.drawerKey,
        drawer: ScreenDrawer(),
        body: Container(
            color: CodeRedColors.base,
            child: SafeArea(
                child: Scaffold(
                    bottomNavigationBar: isKeyboardVisible(context)
                        ? null
                        : NavBar(
                            currentIndex: currentIndex,
                            onChange: _navbarChangeHandler),
                    body: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: _pageChangeHandler,
                        children: [
                          TransitionWrapper(
                              ltr: leftToRight, child: HomeScreen()),
                          TransitionWrapper(
                              ltr: leftToRight, child: StatsScreen()),
                          TransitionWrapper(
                              ltr: leftToRight,
                              child: ForumsScreen(refresh: widget.refresh)),
                          TransitionWrapper(
                              ltr: leftToRight, child: ConsultDoctor()),
                        ])))),
      ),
    );
  }

  void _navbarChangeHandler(index) {
    _pageController.jumpToPage(index);
    setState(() => currentIndex = index);
  }

  // Handles PageView Tab Change
  void _pageChangeHandler(index) {
    setState(() {
      leftToRight = index < currentIndex;
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class DummyScreen extends StatelessWidget {
  final String title;

  DummyScreen({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(title)));
  }
}
