import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/forums/post_user.dart';
import '../../../services/database/storage.dart';
import '../../../services/index.dart';
import '../../../utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PostUpload extends StatefulWidget {
  final String body;
  final String title;
  final Asset image;
  final PostUserModel user;

  const PostUpload(
      {@required this.body,
      @required this.title,
      @required this.image,
      @required this.user,
      Key key})
      : super(key: key);

  @override
  _PostUploadState createState() => _PostUploadState();
}

class _PostUploadState extends State<PostUpload> with TickerProviderStateMixin {
  AnimationController _controller;

  final bool _error = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _addDocToFirestore();
  }

  void _addDocToFirestore() async {
    print('ADDING POST TO FIREBASE');

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
      final _ = await getImageFileFromAssets(widget.image);

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
      backgroundColor: const Color(0xffFAFAFA),
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
                ..duration = const Duration(milliseconds: 2500)
                ..forward();
            })
          else
            Lottie.asset('assets/lottie/posting.json',
                width: getContextWidth(context) * 1,
                controller: _controller, onLoaded: (_) {
              _controller
                ..duration = const Duration(milliseconds: 1200)
                ..repeat();
            }),
          const Text('Posting..', style: TextStyle(fontSize: 18))
        ],
      ),
    );
  }
}
