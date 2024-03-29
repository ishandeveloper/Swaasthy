import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codered/models/forums/post_user.dart';
import 'package:codered/services/database/storage.dart';
import 'package:codered/services/index.dart';
import 'package:codered/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PostUpload extends StatefulWidget {
  final String body;
  final String title;
  final Asset image;
  final PostUserModel user;

  PostUpload({
    @required this.body,
    @required this.title,
    @required this.image,
    @required this.user,
  });

  @override
  _PostUploadState createState() => _PostUploadState();
}

class _PostUploadState extends State<PostUpload> with TickerProviderStateMixin {
  AnimationController _controller;

  bool _error = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _addDocToFirestore();
  }

  void _addDocToFirestore() async {
    print("ADDING POST TO FIREBASE");

    if (widget?.image == null) {
      FirebaseFirestore.instance
          .collection('forums')
          .doc('posts')
          .collection('posts')
          .add({
        'type': 0,
        'body': widget.body,
        'replies_count': 0,
        'upvotes_count': 0,
        'title': widget.title,
        'create_ts': FieldValue.serverTimestamp(),
        'user_details': {
          'user_name': widget.user.username,
          'user_id': widget.user.userID,
          'user_image': widget.user.userimage,
        }
      }).then((e) {
        ForumsHelper.resetInteractions();
        Navigator.pushReplacementNamed(context, '/home');

        Phoenix.rebirth(context);
      });
    } else {
      File _ = await getImageFileFromAssets(widget.image);

      await FirebaseFirestore.instance
          .collection('forums')
          .doc('posts')
          .collection('posts')
          .add({
        'type': 1,
        'image': await uploadImage(_),
        'body': widget.body,
        'replies_count': 0,
        'upvotes_count': 0,
        'title': widget.title,
        'create_ts': FieldValue.serverTimestamp(),
        'user_details': {
          'user_name': widget.user.username,
          'user_id': widget.user.userID,
          'user_image': widget.user.userimage,
        }
      }).then((e) {
        ForumsHelper.resetInteractions();
        Navigator.pushReplacementNamed(context, '/home');

        Phoenix.rebirth(context);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(width: getContextWidth(context)),
          if (_error)
            Lottie.asset('assets/lottie/error.json',
                width: getContextWidth(context) * 1,
                controller: _controller, onLoaded: (_) {
              _controller
                ..duration = Duration(milliseconds: 2500)
                ..forward();
            })
          else
            Lottie.asset('assets/lottie/posting.json',
                width: getContextWidth(context) * 1,
                controller: _controller, onLoaded: (_) {
              _controller
                ..duration = Duration(milliseconds: 1200)
                ..repeat();
            }),
          Text("Posting..", style: TextStyle(fontSize: 18))
        ],
      ),
    );
  }
}
