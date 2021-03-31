import 'dart:async';

import 'package:codered/models/medicine_reminder.dart';
import 'package:codered/utils/constants/colors.dart';
import 'package:codered/utils/helpers/interactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../main.dart';

class NewReminder extends StatefulWidget {
  const NewReminder({Key key}) : super(key: key);

  @override
  _NewReminderState createState() => _NewReminderState();
}

class _NewReminderState extends State<NewReminder> {
  TextEditingController medicineNameController = TextEditingController();
  TextEditingController daysController = TextEditingController();
  String time = '';
  bool loader = false;

  @override
  void initState() {
    super.initState();
    _getTime(DateTime.now());
  }

  void _getTime(DateTime dateTime) {
    setState(() {
      time = specialTimeFormatter(dateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
                width: 32,
                height: 32,
                child:
                    Icon(Icons.arrow_back_ios, size: 16, color: Colors.black))),
        title: Text(
          'NEW REMINDER',
          style: TextStyle(fontFamily: 'ProductSans', color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height * 0.08,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: medicineNameController,
                decoration: InputDecoration(
                    hintText: 'Enter Medicine Name',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                    border: InputBorder.none),
              ),
            ),
            SizedBox(height: height * 0.01),
            GestureDetector(
              onTap: () {
                DatePicker.showTime12hPicker(context, showTitleActions: true,
                    onChanged: (date) {
                  print('change $date in time zone ' +
                      date.timeZoneOffset.inHours.toString());
                  _getTime(date);
                }, onConfirm: (date) {
                  print('confirm $date');
                  _getTime(date);
                }, currentTime: DateTime.now());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                height: height * 0.08,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Time'), Text(time)],
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            Container(
              height: height * 0.08,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: daysController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Enter Number Of Days Of Prescription',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                    border: InputBorder.none),
              ),
            ),
            SizedBox(height: height * 0.02),
            if (medicineNameController.text.length > 1 &&
                daysController.text.length > 0) ...[
              Text("Medicine Reminder details",
                  style: TextStyle(
                    fontSize: 14,
                    color: CodeRedColors.secondaryText,
                    fontFamily: 'ProductSans',
                  )),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(medicineNameController.text,
                      style: TextStyle(
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      )),
                  Text(" on ",
                      style: TextStyle(
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      )),
                  Text(time,
                      style: TextStyle(
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      )),
                  Text(" for ",
                      style: TextStyle(
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      )),
                  Text('${daysController.text} days.',
                      style: TextStyle(
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      )),
                ],
              ),
            ],
            SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: Container(
          width: double.infinity,
          height: height * 0.075,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  loader = true;
                });
                await _scheduleMedicineNotification()
                    .then((value) => Navigator.pop(context));
              },
              child: loader
                  ? Center(child: CircularProgressIndicator())
                  : Text(
                      'CONFIRM',
                      style: TextStyle(fontSize: 18),
                    ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<bool> _scheduleMedicineNotification() async {
    return await flutterLocalNotificationsPlugin
        .zonedSchedule(
            0,
            'weekly scheduled notification title',
            'weekly scheduled notification body',
            _nextInstanceMedicine(),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  'weekly notification channel id',
                  'weekly notification channel name',
                  'weekly notificationdescription'),
            ),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime)
        .then((value) {
      debugPrint('SCHEDULE UPDATE');
      return true;
    });
  }

  tz.TZDateTime _nextInstanceMedicine() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    int hr = int.parse(time.split(':')[0]);
    int min = int.parse(time.split(':')[1].split(' ')[0]);
    debugPrint(hr.toString() + ' ' + min.toString());
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hr, min);
    for (int i = 0; i < int.parse(daysController.text); i++) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
      Provider.of<MedicineReminderService>(context, listen: false).updateList(
          MedicineReminderData(
              time: scheduledDate,
              title: medicineNameController.text,
              description: 'Description'));
    }

    debugPrint(scheduledDate.toString());
    return scheduledDate;
  }
}
