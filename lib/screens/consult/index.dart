import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codered/models/consult/appointment.dart';
import 'package:codered/screens/index.dart';
import 'package:codered/services/database/consult.dart';
import 'package:codered/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../indicator.dart';
import 'local_widgets/index.dart';

class ConsultDoctor extends StatefulWidget {
  final int? userType;

  ConsultDoctor({required this.userType});

  @override
  _ConsultDoctorState createState() => _ConsultDoctorState();
}

class _ConsultDoctorState extends State<ConsultDoctor> {
  // Tracks whether the current user already has any appointments or not
  bool hasAppointments = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: ConsultHelper.getAppointmentsSnapshot(
                userType: widget.userType, userID: user.uid
                // userID: "qUOmsgFAwKPHaBSAWTnLah7sjMd2",
                // userID: "fm4kdMY8alSg7byooUH9OkO2Wik2"
                ),
            builder: (_,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (!snapshot.hasData)
                return ShimmeringConsultPage(userType: widget.userType);

              if (!snapshot.data!.exists)
                return NoAppointments(
                  userType: widget.userType,
                );

              return AppointmentsList(
                  userType: widget.userType,
                  appointment: Appointment.getModel(snapshot.data!));
            },
          ),
        ));
  }
}

class AppointmentsList extends StatelessWidget {
  final Appointment appointment;
  final int? userType;

  AppointmentsList({required this.appointment, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConsultHeader(action: true, userType: userType),
        Expanded(
          child: SingleChildScrollView(
              child: Container(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: appointment.appointments!.length,
                  itemBuilder: (_, index) => AppointmentCard(
                      data: appointment.appointments![index],
                      userType: this.userType)),
            ),
          )),
        ),
      ],
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final AppointmentItem? data;

  final int? userType;

  AppointmentCard({this.data, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 4,
              offset: Offset(0, 0),
            )
          ],
          borderRadius: BorderRadius.circular(5)),
      width: getContextWidth(context) - 32,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(color: CodeRedColors.primary2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Appointment Details',
                      style:
                          TextStyle(color: Color.fromRGBO(255, 255, 255, 0.9))),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white, size: 32),
                      SizedBox(width: 8),
                      Text(dateTimeFormatter(data!.timestamp!.toDate()),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600))
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50)),
                    height: 102,
                    padding:
                        EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                    child: Hero(
                      tag: data!.doctorID!,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image(
                            image:
                                CachedNetworkImageProvider(data!.doctorImage!),
                          )),
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            userType == 2
                                ? '${data!.doctorName}'
                                : 'Dr. ${data!.doctorName}',
                            style: TextStyle(fontSize: 22)),
                        MaterialButton(
                          color: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          elevation: 0,
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AppointmentDetails(
                                        data: data,
                                        userType: this.userType,
                                      ))),
                          child: Text('View details'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmeringConsultPage extends StatelessWidget {
  final int? userType;

  ShimmeringConsultPage({required this.userType});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        ConsultHeader(userType: userType),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Shimmer.fromColors(
              child: ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemCount: 2,
                separatorBuilder: (BuildContext context, int index) => Divider(
                  thickness: 32,
                  color: Colors.transparent,
                ),
                itemBuilder: (BuildContext context, int index) => Container(
                  height: 172,
                  width: getContextWidth(context) - 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[100]!),
        )
      ],
    ));
  }
}

class ConsultHeader extends StatelessWidget {
  final bool action;
  final int? userType;

  const ConsultHeader({Key? key, this.action = false, required this.userType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Consult a doctor',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              fontFamily: 'ProductSans',
            ),
          ),
          AnimatedOpacity(
            opacity: this.action && this.userType != 2 ? 1 : 0,
            duration: Duration(milliseconds: 400),
            child: FloatingActionButton(
              mini: true,
              onPressed: () => Navigator.pushNamed(context, '/bookdoctor'),
              backgroundColor: CodeRedColors.primary2,
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
