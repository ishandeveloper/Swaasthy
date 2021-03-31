import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codered/models/forums/post_user.dart';
import 'package:codered/utils/index.dart';
import 'package:flutter/material.dart';

class ForumPostModel {
  final String content;
  final String postID;
  final String title;
  final DocumentReference reference;
  final ForumPostType type;
  final PostUserModel user;
  final String thumbnail;
  final String body;
  final String image;
  final Timestamp timestamp;

  ForumPostModel(
      {Key key,
      this.postID,
      this.content,
      this.type,
      this.user,
      this.reference,
      this.title,
      this.thumbnail,
      this.body,
      this.timestamp,
      this.image});

  factory ForumPostModel.getModel(
      Map<String, dynamic> data, String docID, DocumentReference ref) {
    return ForumPostModel(
      postID: docID,
      title: data['title'] as String,
      type: checkForumPostType(data['type']),
      body: data['body'] as String,
      image: checkForumPostType(data['type']) == ForumPostType.singleimage
          ? data['image']
          : null,
      user: PostUserModel.getUser(data['user_details']),
      timestamp: data['create_ts'],
      key: Key(data['body'] + data['timestamp'].toString()),
      reference: ref,
    );
  }
}
