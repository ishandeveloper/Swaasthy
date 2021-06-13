import '../../../../utils/index.dart';
import 'package:flutter/material.dart';

class NoAppointments extends StatelessWidget {
  final int userType;

  const NoAppointments({@required this.userType, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: MediaQuery.of(context).size.width),
        const Text('Consult a doctor', style: TextStyle(fontSize: 24)),
        Container(
            height: 200,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/doctor.png')))),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 42, vertical: 12),
            child: Text(
                'Use this service to interact, discuss , take advice and resolve your concerns with trained doctors and physicians over the world.',
                textAlign: TextAlign.center)),
        const SizedBox(height: 12),
        if (userType != 2)
          MaterialButton(
              color: CodeRedColors.primary2,
              onPressed: () => Navigator.pushNamed(context, '/bookdoctor'),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: const Text('Book an appointment',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)))
      ],
    );
  }
}
