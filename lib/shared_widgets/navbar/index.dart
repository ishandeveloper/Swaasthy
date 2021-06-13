/* 
  This widget accepts the current index and an onchange handler function and
  returns the bottom navigation bar 
*/

import '../../utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class NavBar extends StatefulWidget {
  final int currentIndex;
  final Function onChange;

  const NavBar({@required this.currentIndex, @required this.onChange, Key key})
      : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return TitledBottomNavigationBar(
        currentIndex: widget.currentIndex,
        enableShadow: false,
        onTap: widget.onChange,
        activeColor: widget.currentIndex == 3
            ? CodeRedColors.primary2
            : CodeRedColors.primary,
        items: [
          TitledNavigationBarItem(
              title:
                  const Icon(Ionicons.ios_home, color: CodeRedColors.inactive),
              icon: Ionicons.ios_home),
          TitledNavigationBarItem(
              title:
                  const Icon(Ionicons.ios_stats, color: CodeRedColors.inactive),
              icon: Ionicons.ios_stats),
          TitledNavigationBarItem(
              title: const Icon(Ionicons.md_chatbubbles,
                  color: CodeRedColors.inactive),
              icon: Ionicons.md_chatbubbles),
          TitledNavigationBarItem(
              title:
                  const Icon(Ionicons.md_medkit, color: CodeRedColors.inactive),
              icon: Ionicons.md_medkit),
        ]);
  }
}
