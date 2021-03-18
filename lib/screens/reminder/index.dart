import 'package:codered/utils/constants/colors.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> medicineData = [
  {
    'time': DateTime.now(),
    'title': 'Diabetes Tablets',
    'description': 'Take Starvog M 0.3 tablets along with water',
  },
];

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
              MedicineReminderAppBar(),
              SliverPadding(
                padding: EdgeInsets.only(left: 24, right: 24, top: 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    MaterialButton(
                        color: CodeRedColors.inputFields,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        onPressed: () {},
                        child: Icon(Icons.add, size: 28))
                  ]),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.only(top: 32, left: 24, right: 24),
                sliver: SliverList(
                    delegate: SliverChildListDelegate([
                  Text('Upcoming Reminders',
                      style: TextStyle(color: Color(0xff828282), fontSize: 16))
                ])),
              ),
              // CONTENT
              SliverPadding(
                padding: EdgeInsets.only(top: 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var _currentRecord = medicineData[index];

                      return Container(
                          height: 120,
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          margin: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.15),
                                    offset: Offset(0, 1),
                                    blurRadius: 2)
                              ],
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width -
                                    48 -
                                    32 -
                                    100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_currentRecord['time'].toString(),
                                        style: TextStyle(
                                            color: Color(0xff828282),
                                            fontSize: 10)),
                                    SizedBox(height: 10),
                                    Text(_currentRecord['title'],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20)),
                                    SizedBox(height: 4),
                                    Text(_currentRecord['description'],
                                        style: TextStyle(
                                            color: Color(0xff828282),
                                            fontSize: 14))
                                  ],
                                ),
                              ),
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: AssetImage(
                                            'assets/images/tablets.png'))),
                              )
                            ],
                          ));
                    },
                    childCount: medicineData.length,
                  ),
                ),
              ),
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
              child: Container(
                  width: 32,
                  height: 32,
                  child: Icon(Icons.arrow_back_ios,
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
        titlePadding: EdgeInsets.only(left: 42, bottom: 16),
        stretchModes: [StretchMode.blurBackground],
        collapseMode: CollapseMode.pin,
        centerTitle: false,
        background: Container(
            color: Colors.white,
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        alignment: Alignment.centerRight,
                        image: AssetImage('assets/images/med-hero.png'))))),
        title: Text(
          "Medicine Reminder",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
        ),
      ),
    );
  }
}
