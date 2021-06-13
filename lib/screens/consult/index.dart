import 'package:cached_network_image/cached_network_image.dart';
import '../../models/consult/appointment.dart';
import '../index.dart';
import '../../services/database/consult.dart';
import '../../utils/index.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../indicator.dart';
import 'local_widgets/index.dart';

class ConsultDoctor extends StatefulWidget {
  final int userType;

  const ConsultDoctor({@required this.userType, Key key}) : super(key: key);

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
          child: StreamBuilder(
            stream: ConsultHelper.getAppointmentsSnapshot(
                userType: widget.userType, userID: user.uid
                // userID: "qUOmsgFAwKPHaBSAWTnLah7sjMd2",
                // userID: "fm4kdMY8alSg7byooUH9OkO2Wik2"
                ),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return ShimmeringConsultPage(userType: widget.userType);

              if (!snapshot.data.exists)
                return NoAppointments(
                  userType: widget.userType,
                );

              return AppointmentsList(
                  userType: widget.userType,
                  appointment: Appointment.getModel(snapshot.data));
            },
          ),
        ));
  }
}

class AppointmentsList extends StatelessWidget {
  final Appointment appointment;
  final int userType;

  const AppointmentsList(
      {@required this.appointment, @required this.userType, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConsultHeader(action: true, userType: userType),
        Expanded(
          child: SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: appointment.appointments.length,
                itemBuilder: (_, index) => AppointmentCard(
                    data: appointment.appointments[index], userType: userType)),
          )),
        ),
      ],
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final AppointmentItem data;

  final int userType;

  const AppointmentCard({this.data, @required this.userType, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              blurRadius: 4,
              offset: const Offset(0, 0),
            )
          ],
          borderRadius: BorderRadius.circular(5)),
      width: getContextWidth(context) - 32,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(color: CodeRedColors.primary2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Appointment Details',
                      style:
                          TextStyle(color: Color.fromRGBO(255, 255, 255, 0.9))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          color: Colors.white, size: 32),
                      const SizedBox(width: 8),
                      Text(dateTimeFormatter(data.timestamp.toDate()),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600))
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50)),
                    height: 102,
                    padding: const EdgeInsets.only(
                        top: 5, left: 5, right: 5, bottom: 5),
                    child: Hero(
                      tag: data.doctorID,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image(
                            image: CachedNetworkImageProvider(data.doctorImage),
                          )),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            userType == 2
                                ? '${data.doctorName}'
                                : 'Dr. ${data.doctorName}',
                            style: const TextStyle(fontSize: 22)),
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
                                        userType: userType,
                                      ))),
                          child: const Text('View details'),
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
  final int userType;

  const ShimmeringConsultPage({@required this.userType, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
    ConsultHeader(userType: userType),
    const SizedBox(height: 24),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Shimmer.fromColors(
          child: ListView.separated(
            primary: false,
            shrinkWrap: true,
            itemCount: 2,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
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
          baseColor: Colors.grey[200],
          highlightColor: Colors.grey[100]),
    )
      ],
    );
  }
}

class ConsultHeader extends StatelessWidget {
  final bool action;
  final int userType;

  const ConsultHeader({Key key, this.action = false, @required this.userType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Consult a doctor',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              fontFamily: 'ProductSans',
            ),
          ),
          AnimatedOpacity(
            opacity: action && userType != 2 ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            child: FloatingActionButton(
              mini: true,
              onPressed: () => Navigator.pushNamed(context, '/bookdoctor'),
              backgroundColor: CodeRedColors.primary2,
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
