import 'package:codered/models/index.dart';
import 'package:codered/screens/emergency/local_widgets/first_aid/index.dart';
import 'package:flutter/material.dart';

class EmergencyConfirmationSheet extends StatefulWidget {
  final Function onConfirm;
  final Ambulance ambulance;

  EmergencyConfirmationSheet({@required this.onConfirm, this.ambulance});

  @override
  _EmergencyConfirmationSheetState createState() =>
      _EmergencyConfirmationSheetState();
}

class _EmergencyConfirmationSheetState
    extends State<EmergencyConfirmationSheet> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Material(
          elevation: 8.0,
          child: Container(
            padding: EdgeInsets.only(top: 8, bottom: 32),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                ),
                SizedBox(height: 24),
                Text("Medical Emergency",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text("You're requesting for medical services",
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
                SizedBox(height: 14),
                MaterialButton(
                  color: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                FirstAidSteps(ambulance: widget.ambulance)));
                    // Navigator.pushReplacementNamed(context, '/firstaid');
                  },
                  child: Text('CONFIRM LOCATION',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                      "Upon confirmation, We'll be dispatching the nearest medical vehicle to your location. Volunteers in your area may also be notified of the same",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700])),
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.black,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text("Misusing this feature will lead to permanent ban",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black))
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
