import 'package:codered/screens/stats/map.dart';
import 'package:codered/utils/index.dart';
import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
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
          SizedBox(height: 32),
          Expanded(
              child: SingleChildScrollView(
            child: Container(
              height: getContextHeight(context) - 196,
              padding: EdgeInsets.only(left: 2, right: 2, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Last week', style: TextStyle(fontSize: 20)),
                  Row(children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.trending_up,
                                    color: CodeRedColors.primary, size: 42),
                                Text('132%', style: TextStyle(fontSize: 28))
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Wrap(
                                children: [
                                  Text('number of infected people',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: CodeRedColors.secondaryText),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            )
                          ]),
                    )),
                    Container(width: 1.5, color: Colors.grey[300], height: 72),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.trending_up,
                                    color: CodeRedColors.primary, size: 42),
                                Text('287%', style: TextStyle(fontSize: 28))
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Wrap(
                                children: [
                                  Text('increase in people suffering from cold',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: CodeRedColors.secondaryText),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            )
                          ]),
                    )),
                  ]),
                  SizedBox(height: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Disease Heatmap', style: TextStyle(fontSize: 20)),
                        SizedBox(height: 8),
                        Expanded(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: MapSample())),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ))
        ]),
      ),
    );
  }
}
