import 'package:codered/screens/indicator.dart';
import 'package:codered/utils/index.dart';
import 'package:flutter/material.dart';

class HomeGreetings extends StatelessWidget {
  const HomeGreetings({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("How're you feeling today?",
              style: TextStyle(
                  letterSpacing: -0.4,
                  color: CodeRedColors.secondaryText,
                  fontSize: 24)),
          SizedBox(height: 5),
          Text(user.username,
              style: TextStyle(
                  color: CodeRedColors.primary,
                  fontSize: 34,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
