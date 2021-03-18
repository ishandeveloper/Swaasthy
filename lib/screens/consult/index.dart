import 'package:flutter/material.dart';

import 'local_widgets/index.dart';

class ConsultDoctor extends StatefulWidget {
  @override
  _ConsultDoctorState createState() => _ConsultDoctorState();
}

class _ConsultDoctorState extends State<ConsultDoctor> {

  // Tracks whether the current user already has any appointments or not
  bool hasAppointments = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: NoAppointments());
  }
}
