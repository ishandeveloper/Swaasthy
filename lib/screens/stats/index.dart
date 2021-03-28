import 'package:codered/screens/stats/map.dart';
import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 24),
            Row(
              children: [
                Text(
                  'In your area',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'ProductSans',
                  ),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: MapSample(),
            )
          ],
        ),
      ),
    );
  }
}
