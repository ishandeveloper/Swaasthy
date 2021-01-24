import 'package:codered/screens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(CodeRedApp());
}

class CodeRedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code Red',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder()
          }),
          textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Product Sans', displayColor: Color(0xff2A2A2A))),
      home: ScreensWrapper(),
    );
  }
}
