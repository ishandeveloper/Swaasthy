import 'dart:async';

import '../../models/medicine_reminder.dart';
import '../../utils/constants/colors.dart';
import '../../utils/helpers/interactions.dart';
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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: const SizedBox(
                width: 32,
                height: 32,
                child:  Icon(Icons.arrow_back_ios,
                    size: 16, color: Colors.black))),
        title: const Text(
          'NEW REMINDER',
          style: TextStyle(fontFamily: 'ProductSans', color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
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
                decoration: const InputDecoration(
                    hintText: 'Enter Medicine Name',
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
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
                  children: [const Text('Time'), Text(time)],
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
                decoration: const InputDecoration(
                    hintText: 'Enter Number Of Days Of Prescription',
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    border: InputBorder.none),
              ),
            ),
            SizedBox(height: height * 0.02),
            if (medicineNameController.text.length > 1 &&
                daysController.text.length > 0) ...[
              const Text('Medicine Reminder details',
                  style: TextStyle(
                    fontSize: 14,
                    color: CodeRedColors.secondaryText,
                    fontFamily: 'ProductSans',
                  )),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(medicineNameController.text,
                      style: const TextStyle(
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      )),
                  const Text(' on ',
                      style: TextStyle(
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      )),
                  Text(time,
                      style: const TextStyle(
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      )),
                  const Text(' for ',
                      style: TextStyle(
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      )),
                  Text('${daysController.text} days.',
                      style: const TextStyle(
                        fontFamily: 'ProductSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      )),
                ],
              ),
            ],
            const SizedBox(height: 16),
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
                  ? const Center(child: CircularProgressIndicator())
                  : const Text(
                      'CONFIRM',
                      style: TextStyle(fontSize: 18),
                    ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<bool> _scheduleMedicineNotification() async {
    return  flutterLocalNotificationsPlugin
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
    final now = tz.TZDateTime.now(tz.local);
    final hr = int.parse(time.split(':')[0]);
    final min = int.parse(time.split(':')[1].split(' ')[0]);
    debugPrint(hr.toString() + ' ' + min.toString());
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hr, min);
    for (var i = 0; i < int.parse(daysController.text); i++) {
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
