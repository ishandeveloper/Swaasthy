import 'package:codered/utils/index.dart';
import 'package:flutter/material.dart';

import '../index.dart';

class HomeCardActions extends StatelessWidget {
  const HomeCardActions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HalfWidthHomeCard(
                background: CodeRedColors.medicineCard,
                header: 'Reminder',
                subText: 'Medicine',
                imagePath: 'assets/images/medicine-reminder.png',
                path: '/reminder'),
            HalfWidthHomeCard(
                background: Colors.white,
                header: 'Patients',
                subText: 'Connect with',
                imagePath: 'assets/images/connect.png',
                path: '/forums')
          ],
        ),
        SizedBox(height: 10),
        FullWidthHomeCard(
            subText: 'Consult a',
            header: 'Doctor',
            imagePath: 'assets/images/doctor.png',
            background: Colors.white)
      ],
    );
  }
}
