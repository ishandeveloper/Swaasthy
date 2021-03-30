import 'package:codered/models/diagnosis.dart';
import 'package:codered/services/daignosis_notifier.dart';
import 'package:codered/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiagnosisReport extends StatefulWidget {
  @override
  _DiagnosisReportState createState() => _DiagnosisReportState();
}

class _DiagnosisReportState extends State<DiagnosisReport> {
  PageController pageController = PageController();
  int currentIndex = 0;

  Widget pageView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Data',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: 10),
          Text('also known as \'Data\''),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
                children: [
                  TextSpan(text: 'There is a '),
                  TextSpan(
                      text: 'data%',
                      style: TextStyle(color: CodeRedColors.primary)),
                  TextSpan(text: ' accuracy with this result.')
                ],
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'ProductSans')),
          ),
          SizedBox(height: 10),
          Text(
            'We recommend consulting a \'data\' doctor.',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Text(
                'Consult a doctor',
                style: TextStyle(fontSize: 18),
              ),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DiagnosisResultNotifier>(builder: (context, dsn, child) {
      //TODO: Check here
      if (dsn.diagnosisResult == null)
        return Center(
          child: CircularProgressIndicator(),
        );
      else
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Diagnosis Result',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              )),
          Flexible(
            flex: 6,
            fit: FlexFit.tight,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        offset: Offset(0, -3),
                        color: Colors.grey[300],
                        blurRadius: 5)
                  ]),
                  child: PageView(
                    controller: pageController,
                    // children: dsn.diagnosisResult.diagnosisResult
                    //     // .sublist(0, 1)
                    //     .map((e) => pageView(e))
                    //     .toList()
                    children: [
                      pageView(),
                      pageView(),
                    ],
                    onPageChanged: (value) {
                      currentIndex = value;
                      setState(() {});
                      return currentIndex;
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            height: 38,
                            width: 38,
                            child: currentIndex == 0
                                ? FloatingActionButton(
                                    backgroundColor: Colors.grey[400],
                                    child: Icon(Icons.arrow_forward_ios_rounded,
                                        size: 15, color: Colors.black),
                                    onPressed: () {
                                      if (pageController.hasClients) {
                                        pageController.animateToPage(1,
                                            duration:
                                                Duration(milliseconds: 200),
                                            curve: Curves.ease);
                                      }
                                    })
                                : SizedBox()),
                        Chip(
                          label: Text('result ${currentIndex + 1} of 2'),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                        ),
                        Container(
                            height: 38,
                            width: 38,
                            child: currentIndex == 1
                                ? FloatingActionButton(
                                    backgroundColor: Colors.grey,
                                    child: Icon(Icons.arrow_back_ios_rounded,
                                        size: 15, color: Colors.black),
                                    onPressed: () {
                                      if (pageController.hasClients) {
                                        pageController.animateToPage(0,
                                            duration:
                                                Duration(milliseconds: 200),
                                            curve: Curves.ease);
                                      }
                                    })
                                : SizedBox())
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Container(
                width: double.infinity,
                color: CodeRedColors.primary,
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Text(
                        'Are you suffering from Nosebleed from past few days?',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Row(
                        children: [
                          Chip(
                            label: Text('Yes'),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Chip(
                            label: Text('No'),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Chip(
                            label: Text('I prefer not to say'),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Container(
                        color: Colors.transparent.withOpacity(0.4),
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text(
                                  'If you wish to do so, this data will be collected anonymously and used to provide you better info about your area',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white)),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ))
        ],
      );
    });
  }
}
