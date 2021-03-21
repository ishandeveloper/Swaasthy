import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codered/models/index.dart';
import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;

class ForumPostHeader extends StatelessWidget {
  final Timestamp timestamp;
  final PostUserModel user;

  ForumPostHeader({this.user, this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(user.userimage),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(user.userID,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Text(timeago.format(timestamp.toDate()),
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.5), fontSize: 12))
            ],
          )
        ],
      ),
    );
  }
}
