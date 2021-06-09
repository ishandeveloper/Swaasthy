/*
  This widget accepts a child and a direction boolean and returns a wrapped
  version of the child, which self animates during intialization
*/

import 'package:flutter/material.dart';

class TransitionWrapper extends StatefulWidget {
  final Widget child;
  final bool? ltr;
  TransitionWrapper({
    required this.child,
    required this.ltr,
  });

  @override
  _TransitionWrapperState createState() => _TransitionWrapperState();
}

class _TransitionWrapperState extends State<TransitionWrapper>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> transformAnimation;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 250), vsync: this)
          ..addListener(() => setState(() {}));

    if (!widget.ltr!) {
      transformAnimation = Tween(begin: 25.0, end: 0.0).animate(controller);
    } else {
      transformAnimation = Tween(begin: -25.0, end: 0.0).animate(controller);
    }
    opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(controller);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacityAnimation.value,
      child: Transform.translate(
          offset: Offset(transformAnimation.value, 0.0), child: widget.child),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
