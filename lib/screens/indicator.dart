import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codered/services/router/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:codered/models/user.dart' as usr;
import 'package:flutter/material.dart';

usr.User user;

class Indicator extends StatefulWidget {
  final User authUser;

  const Indicator({Key key, this.authUser}) : super(key: key);
  @override
  _IndicatorState createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  @override
  void initState() {
    super.initState();
    checkUserExistance();
  }

  checkUserExistance() async {
    if (widget.authUser != null) {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('users');

      final DocumentSnapshot value =
          await collectionReference.doc(widget.authUser.uid).get();
      if (value.exists) {
        user = usr.User.fromJson(value.data());
        setState(() {});
        Navigator.pushNamedAndRemoveUntil(
            context, CodeRedRoutes.home, (route) => false);
      } else {
        user = usr.User(
            points: 0, email: widget.authUser.email, uid: widget.authUser.uid);
        setState(() {});
        await collectionReference
            .doc(widget.authUser.uid)
            .set(user.toJson())
            .then((value) => Navigator.pushNamedAndRemoveUntil(
                context, CodeRedRoutes.signup, (route) => false));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
