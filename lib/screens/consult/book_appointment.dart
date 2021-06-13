import '../../models/index.dart';
import '../../services/index.dart';
import '../../utils/index.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../index.dart';
import 'local_widgets/index.dart';

class BookAppointment extends StatefulWidget {
  const BookAppointment({Key key}) : super(key: key);
  @override
  _BookAppointmentState createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  List<Doctor> _hDoctors = [];
  List<Doctor> _trDoctors = [];

  /// **********************************************
  /// ACTIONS
  /// **********************************************

  void _onCellTap(Doctor doctor) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Scaffold(body: DoctorDetailPage(doctor: doctor)),
        ));
  }

  @override
  void initState() {
    super.initState();
    getHeroDoctors();
    getTopRatedDoctors();
  }

  void getHeroDoctors() async {
    final _ = await ConsultHelper.getHeroDoctors();
    setState(() => _hDoctors = _);
  }

  void getTopRatedDoctors() async {
    final _ = await ConsultHelper.getTopRatedDoctors();
    setState(() => _trDoctors = _);
  }

  /// Highlighted Doctors Section
  SizedBox _hDoctorsSection() {
    if (_hDoctors.length == 0)
      return SizedBox(
        height: 199,
        child: Shimmer.fromColors(
          direction: ShimmerDirection.ltr,
          baseColor: Colors.grey[200],
          highlightColor: Colors.grey[100],
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(5)),
            height: 178,
            width: getContextWidth(context) - 54,
          ),
        ),
      );

    return SizedBox(
      height: 199,
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _hDoctors.length,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(indent: 16),
        itemBuilder: (BuildContext context, int index) => HDCell(
          doctor: _hDoctors[index],
          onTap: () => _onCellTap(_hDoctors[index]),
        ),
      ),
    );
  }

  /// Top Rated Doctors Section
  Widget _trDoctorsSection() {
    if (_trDoctors.length == 0)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Rated Doctors',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Shimmer.fromColors(
              child: ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemCount: 5,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  thickness: 16,
                  color: Colors.transparent,
                ),
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  onTap: () => _onCellTap(_trDoctors[index]),
                  child: Container(
                    height: 108,
                    width: getContextWidth(context) - 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              baseColor: Colors.grey[200],
              highlightColor: Colors.grey[100])
        ],
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Rated Doctors',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemCount: _trDoctors.length,
          separatorBuilder: (BuildContext context, int index) => const Divider(
            thickness: 16,
            color: Colors.transparent,
          ),
          itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () => _onCellTap(_trDoctors[index]),
              child: TopRatedDoctorCell(doctor: _trDoctors[index])),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: SafeArea(child: BookAppointmentHeader()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            _hDoctorsSection(),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _trDoctorsSection(),
            ),
          ]),
        ),
      ),
    );
  }
}

class BookAppointmentHeader extends StatelessWidget {
  const BookAppointmentHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                  color: CodeRedColors.icon,
                  iconSize: 24,
                  splashRadius: 20,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context)),
              const SizedBox(width: 8),
              const Text(
                'Choose a doctor',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'ProductSans',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
