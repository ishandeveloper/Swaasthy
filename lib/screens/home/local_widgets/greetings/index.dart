import '../../../indicator.dart';
import '../../../../utils/index.dart';
import 'package:flutter/material.dart';

class HomeGreetings extends StatelessWidget {
  const HomeGreetings({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const  EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("How're you feeling today?",
              style: TextStyle(
                  letterSpacing: -0.4,
                  color: CodeRedColors.secondaryText,
                  fontSize: 24)),
          const SizedBox(height: 5),
          Text(user.username,
              style: const TextStyle(
                  color: CodeRedColors.primary,
                  fontSize: 34,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
