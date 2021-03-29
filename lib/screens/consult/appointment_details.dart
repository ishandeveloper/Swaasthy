import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:codered/models/consult/appointment.dart';
import 'package:codered/utils/constants/colors.dart';
import 'package:codered/utils/helpers/interactions.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../index.dart';
import '../indicator.dart';

class AppointmentDetails extends StatelessWidget {
  final AppointmentItem data;
  final int userType;

  AppointmentDetails({@required this.data, @required this.userType});

  void _initVideoCall(BuildContext context) async {
    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AppointmentCall(
            appointmentID: data.id, role: ClientRole.Broadcaster),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 72,
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: MaterialButton(
                onPressed: () => _initVideoCall(context),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                color: CodeRedColors.primary2Accent,
                child: Text('Join appointment',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppointmentDetailsHeader(
              data: data, initVideoCall: _initVideoCall, userType: userType),
          SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: getContextWidth(context) * 0.15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (userType == 2) SizedBox(height: 16),
                          if (userType != 2)
                            Text('Dr.',
                                style: TextStyle(
                                    fontSize: 36, fontWeight: FontWeight.w500)),
                          Text(data.doctorName,
                              style: TextStyle(
                                  fontSize: userType == 2 ? 34 : 38,
                                  fontWeight: FontWeight.w600)),
                        ]),
                  ),
                  SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFd4faff),
                            border: Border(
                                left: BorderSide(
                                    color: Color(0xFF1ddef2), width: 2))),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        width: getContextWidth(context) * 0.7,
                        child: Wrap(
                          children: [
                            Row(
                              children: [
                                Text(
                                    "Hello ${user.username?.split(" ")[0]?.toString()},",
                                    style: TextStyle(fontSize: 17)),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                  "I might need to take a look at your diabetic reports, during the appointment, please keep them handy if possible."),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    await permission.request();
  }
}

class AppointmentDetailsHeader extends StatelessWidget {
  const AppointmentDetailsHeader({
    Key key,
    @required this.data,
    @required this.initVideoCall,
    @required this.userType,
  }) : super(key: key);

  final AppointmentItem data;
  final Function initVideoCall;
  final int userType;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 8, bottom: 72),
              decoration: BoxDecoration(
                  color: CodeRedColors.primary2,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(120))),
              width: getContextWidth(context),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context)),
                        Text(
                          'Appointment Details',
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.9),
                              fontSize: 16),
                        )
                      ],
                    ),
                    SizedBox(height: 52),
                    Text(dateFormatter(this.data.timestamp.toDate()),
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                        )),
                    Text(specialTimeFormatter(this.data.timestamp.toDate()),
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(height: 54)
          ],
        ),
        Positioned(
            bottom: 0,
            left: getContextWidth(context) * 0.15,
            right: getContextWidth(context) * 0.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFFAFAFA), width: 5),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50)),
                  height: 102,
                  padding: EdgeInsets.all(5),
                  child: Hero(
                    tag: data.doctorID,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image(
                        image: CachedNetworkImageProvider(data.doctorImage),
                      ),
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Prescription',
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFFAFAFA), width: 5),
                    ),
                    child: MaterialButton(
                      shape: CircleBorder(),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AppointmentPrescription(
                                  data: data, userType: userType))),
                      padding: EdgeInsets.all(12),
                      color: CodeRedColors.primary2,
                      child: Icon(Icons.list, color: Colors.white, size: 32),
                    ),
                  ),
                )
              ],
            ))
      ],
    );
  }
}
