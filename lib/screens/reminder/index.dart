import '../../models/medicine_reminder.dart';
import '../../services/router/routes.dart';
import '../../utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicineReminder extends StatefulWidget {
  const MedicineReminder({Key key}) : super(key: key);

  @override
  _MedicineReminderState createState() => _MedicineReminderState();
}

class _MedicineReminderState extends State<MedicineReminder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              const MedicineReminderAppBar(),
              SliverPadding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    MaterialButton(
                        color: CodeRedColors.inputFields,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, CodeRedRoutes.medicineReminder);
                        },
                        child: const Icon(Icons.add, size: 28))
                  ]),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.only(top: 32, left: 24, right: 24),
                sliver: SliverList(
                    delegate: SliverChildListDelegate([
                  const Text('Upcoming Reminders',
                      style: TextStyle(color: Color(0xff828282), fontSize: 16))
                ])),
              ),
              // CONTENT
              Consumer<MedicineReminderService>(builder: (context, mrs, child) {
                return SliverPadding(
                  padding: const EdgeInsets.only(top: 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final _currentRecord = mrs.medicineReminderList[index];
                        // TODO: Add condition to remove list item
                        // if (_currentRecord.time.isAfter(DateTime.now()))
                        return Container(
                            height: 120,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            margin: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.15),
                                      offset: Offset(0, 1),
                                      blurRadius: 2)
                                ],
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width -
                                      48 -
                                      32 -
                                      100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_currentRecord.time.toString(),
                                          style: const TextStyle(
                                              color: Color(0xff828282),
                                              fontSize: 10)),
                                      const SizedBox(height: 10),
                                      Text(_currentRecord.title,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20)),
                                      const SizedBox(height: 4),
                                      Text(_currentRecord.description,
                                          style: const TextStyle(
                                              color: Color(0xff828282),
                                              fontSize: 14))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: AssetImage(
                                              'assets/images/tablets.png'))),
                                )
                              ],
                            ));
                      },
                      childCount: mrs.medicineReminderList.length,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class MedicineReminderAppBar extends StatelessWidget {
  const MedicineReminderAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          InkWell(
              onTap: () => Navigator.pop(context),
              child: const SizedBox(
                  width: 32,
                  height: 32,
                  child:  Icon(Icons.arrow_back_ios,
                      size: 16, color: Colors.black))),
        ],
      ),
      leadingWidth: 0,
      leading: Container(),
      pinned: true,
      expandedHeight: 200,
      elevation: 0,
      forceElevated: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 42, bottom: 16),
        stretchModes: [StretchMode.blurBackground],
        collapseMode: CollapseMode.pin,
        centerTitle: false,
        background: Container(
            color: Colors.white,
            child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        alignment: Alignment.centerRight,
                        image: AssetImage('assets/images/med-hero.png'))))),
        title: const Text(
          'Medicine Reminder',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
        ),
      ),
    );
  }
}
