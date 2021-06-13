import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/diagnosis.dart';
import '../services/apimedic_service.dart';
import '../utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DiagnosisReport extends StatefulWidget {
  final List<int> symptoms;
  const DiagnosisReport({this.symptoms, Key key}) : super(key: key);
  @override
  _DiagnosisReportState createState() => _DiagnosisReportState();
}

class _DiagnosisReportState extends State<DiagnosisReport> {
  PageController pageController = PageController();
  int currentIndex = 0;

  Future<GeoPoint> getLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return GeoPoint(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiMedicService().getInfo(widget.symptoms),
        builder: (context, snapshot) {
          //TODO: Check here
          print(snapshot.data);
          if (snapshot.hasData)
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
                          const Text(
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
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, -3),
                                  color: Colors.grey[300],
                                  blurRadius: 5)
                            ]),
                        child: PageView(
                          controller: pageController,
                          children: snapshot.data.diagnosisResult
                              .sublist(0, 1)
                              .map((e) => pageView(e))
                              .toList(),
                          // children: [
                          //   pageView(),
                          //   pageView(),
                          // ],
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
                              SizedBox(
                                  height: 38,
                                  width: 38,
                                  child: currentIndex == 0
                                      ? FloatingActionButton(
                                          backgroundColor: Colors.grey[400],
                                          child: const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 15,
                                              color: Colors.black),
                                          onPressed: () {
                                            if (pageController.hasClients) {
                                              pageController.animateToPage(1,
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  curve: Curves.ease);
                                            }
                                          })
                                      : const SizedBox()),
                              Chip(
                                label: Text('result ${currentIndex + 1} of 2'),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                              ),
                              SizedBox(
                                  height: 38,
                                  width: 38,
                                  child: currentIndex == 1
                                      ? FloatingActionButton(
                                          backgroundColor: Colors.grey,
                                          child: const Icon(
                                              Icons.arrow_back_ios_rounded,
                                              size: 15,
                                              color: Colors.black),
                                          onPressed: () {
                                            if (pageController.hasClients) {
                                              pageController.animateToPage(0,
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  curve: Curves.ease);
                                            }
                                          })
                                      : const SizedBox())
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
                          const Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Text(
                              'Are you suffering from Nosebleed from past few days?',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    //TODO: Update Disease Name
                                    await FirebaseFirestore.instance
                                        .collection('heatmaps')
                                        .doc('city_name')
                                        .update({
                                      'disease_name': 'Randome',
                                      'geopoint': await getLocation(),
                                      'timestamp': Timestamp.now(),
                                      'symptoms': widget.symptoms
                                    });
                                  },
                                  child: const Chip(
                                    label: Text('Yes'),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Chip(
                                  label: Text('No'),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Chip(
                                  label: Text('I prefer not to say'),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: Container(
                              color: Colors.transparent.withOpacity(0.4),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget pageView(Diagnosis diagnosis) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Data',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 10),
          const Text('also known as \'Data\''),
          const SizedBox(height: 10),
          RichText(
            text: const TextSpan(
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
          const SizedBox(height: 10),
          const Text(
            'We recommend consulting a \'data\' doctor.',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
}
