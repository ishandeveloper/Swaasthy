import 'package:cached_network_image/cached_network_image.dart';
import 'package:codered/models/consult/appointment.dart';
import 'package:codered/utils/constants/colors.dart';
import 'package:codered/utils/helpers/interactions.dart';
import 'package:flutter/material.dart';

class AppointmentDetails extends StatelessWidget {
  final AppointmentItem data;

  AppointmentDetails({@required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 8, bottom: 72),
                    decoration: BoxDecoration(
                        color: CodeRedColors.primary2,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(120))),
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
                          Text(
                              specialTimeFormatter(
                                  this.data.timestamp.toDate()),
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
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFFFAFAFA), width: 5),
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20)),
                        height: 102,
                        padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                        child: Hero(
                            tag: data.doctorID,
                            child: Image(
                              image:
                                  CachedNetworkImageProvider(data.doctorImage),
                            )),
                      ),
                      SizedBox(width: 32),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Color(0xFFFAFAFA), width: 5),
                        ),
                        child: MaterialButton(
                          shape: CircleBorder(),
                          onPressed: () {
                            // _initVideoCall();
                          },
                          padding: EdgeInsets.all(12),
                          color: CodeRedColors.primary2,
                          child: Icon(Icons.videocam,
                              color: Colors.white, size: 32),
                        ),
                      )
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
