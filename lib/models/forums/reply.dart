import 'package:cloud_firestore/cloud_firestore.dart';
import 'post_user.dart';
import 'package:flutter/material.dart';

class ReplyModel {
  // final String uid;
  // final String userName;
  // final String thumbnail;
  final PostUserModel user;
  final String body;
  final String docID;
  final Timestamp timestamp;

  ReplyModel({
    Key key,
    this.user,
    this.docID,
    this.body,
    this.timestamp,
  });

  factory ReplyModel.getModel(Map<String, dynamic> data, docID) {
    return ReplyModel(
        docID: docID,
        body: data['body'] as String,
        user: PostUserModel.getUser(data['user']),
        timestamp: data['timestamp'],
        key: Key(data['body'] + data['timestamp'].toString()));
  }
}
