import 'map.dart';
import '../../utils/index.dart';
import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 24),
          Row(
            children: [
              const Text(
                'In your area',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'ProductSans',
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
              child: SingleChildScrollView(
            child: Container(
              height: getContextHeight(context) - 196,
              padding: const EdgeInsets.only(left: 2, right: 2, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Last week', style: TextStyle(fontSize: 20)),
                  Row(children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.trending_up,
                                    color: CodeRedColors.primary, size: 42),
                                Text('132%', style: TextStyle(fontSize: 28))
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Wrap(
                                children: const [
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
                              children: const [
                                Icon(Icons.trending_up,
                                    color: CodeRedColors.primary, size: 42),
                                Text('287%', style: TextStyle(fontSize: 28))
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Wrap(
                                children: const [
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
                  const SizedBox(height: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Disease Heatmap',
                            style: TextStyle(fontSize: 20)),
                        const SizedBox(height: 8),
                        Expanded(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: const MapSample())),
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
