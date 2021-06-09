import 'package:codered/utils/index.dart';
import 'package:flutter/material.dart';

class NoAppointments extends StatelessWidget {
  final int? userType;

  NoAppointments({required this.userType});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: MediaQuery.of(context).size.width),
        Text('Consult a doctor', style: TextStyle(fontSize: 24)),
        Container(
            height: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/doctor.png')))),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 42, vertical: 12),
            child: Text(
                'Use this service to interact, discuss , take advice and resolve your concerns with trained doctors and physicians over the world.',
                textAlign: TextAlign.center)),
        SizedBox(height: 12),
        if (this.userType != 2)
          MaterialButton(
              color: CodeRedColors.primary2,
              onPressed: () => Navigator.pushNamed(context, '/bookdoctor'),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Text('Book an appointment',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)))
      ],
    );
  }
}
