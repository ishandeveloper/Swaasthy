import 'package:codered/services/index.dart';
import 'package:codered/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../index.dart';

class HomeCardActions extends StatelessWidget {
  const HomeCardActions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreensWrapperService _service =
        Provider.of<ScreensWrapperService>(context, listen: false);

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
              onTap: () => _service.changeIndex(2),
            )
          ],
        ),
        SizedBox(height: 10),
        FullWidthHomeCard(
            subText: 'Consult a',
            header: 'Doctor',
            onTap: () => _service.changeIndex(3),
            imagePath: 'assets/images/doctor.png',
            background: Colors.white)
      ],
    );
  }
}
