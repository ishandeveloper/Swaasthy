import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/forums/posts.dart';
import '../../screens/indicator.dart';
import '../index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Map<String, List> likesMap = {};
Map<String, int> commentsMap = {};

class ForumsHelper {
  static Future<List<ForumPostModel>> getPosts() async {
    return FirebaseFirestore.instance
        .collection('forums')
        .doc('posts')
        .collection('posts')
        .get()
        .then((data) {
      final _postsSnapshots = data.docs;

      final _postsModel = <ForumPostModel>[];

      _postsSnapshots.forEach((snapshot) {
        _postsModel.add(ForumPostModel.getModel(
            snapshot.data(), snapshot.id, snapshot.reference));
      });

      print(_postsModel);

      return _postsModel;
    });
  }

  // This method returns the length of total snapshots of the forum posts collection
  static Future<int> getFeedSnapshotLength() async {
    return FirebaseFirestore.instance
        .collection('forums')
        .doc('posts')
        .collection('posts')
        .get()
        .then((value) => value.docs.length);
  }

  static void addReplyToFirestore({String postID, data}) async {
    await FirebaseFirestore.instance
        .collection('forums')
        .doc('posts')
        .collection('posts')
        .doc(postID)
        .collection('replies')
        .add(data);

    await FirebaseFirestore.instance
        .collection('forums')
        .doc('posts')
        .collection('posts')
        .doc(postID)
        .update({'replies_count': FieldValue.increment(1)});
  }

  // This method returns limited number of first n snapshots of the forum posts collection
  static Future<QuerySnapshot> getLimitedSnapshots(int length,
      {DocumentSnapshot lastDocument}) async {
    var _query = FirebaseFirestore.instance
        .collection('forums')
        .doc('posts')
        .collection('posts')
        .orderBy('create_ts', descending: true);

    // Checks if a last document is provided, then starts fetching more data after last document else default
    if (lastDocument != null)
      _query = FirebaseFirestore.instance
          .collection('forums')
          .doc('posts')
          .collection('posts')
          .orderBy('create_ts', descending: true)
          .startAfterDocument(lastDocument);

    return _query.limit(length).get();
  }

  static void getInteractions(String documentID, int index, int likesCount,
      int commentsCount, BuildContext context) async {
    final _likesService = Provider.of<UpvotesService>(context, listen: false);
    final _commentsService = Provider.of<RepliesService>(context, listen: false);

    var _likes = [];

    if (likesMap.containsKey(documentID)) {
      _likes = likesMap[documentID];
    }

    if (!commentsMap.containsKey(documentID) ||
        !likesMap.containsKey(documentID)) {
      final _likesData = await FirebaseFirestore.instance
          .collection('forums')
          .doc('posts')
          .collection('posts')
          .doc(documentID)
          .collection('upvotes')
          .doc(user.uid)
          .get();

      if (_likesData.exists) {
        final _tempList =
            List<String>.generate(likesCount - 1, (index) => '$index');
        _likes = [user.uid, ..._tempList];
      } else {
        final _tempList = List<String>.generate(likesCount, (index) => '$index');
        _likes = _tempList;
      }

      likesMap.addAll({documentID: _likes});
      commentsMap.addAll({documentID: commentsCount});
      _commentsService.assignCommentsCount(index, commentsCount);
      _likesService.addLikesToList(List<String>.from(_likes), index);
    }
    return Future.value(true);
  }

  static Future<List<DocumentSnapshot>> getComments(
      String documentID, DocumentSnapshot lastDocument) async {
    List<DocumentSnapshot> _commentsData;

    if (lastDocument != null) {
      print('OPTIMIZED FETCH');

      _commentsData = await FirebaseFirestore.instance
          .collection('forums')
          .doc('posts')
          .collection('posts')
          .doc(documentID)
          .collection('replies')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(lastDocument)
          .limit(1)
          .get()
          .then((_) => _.docs);
    } else {
      print('FETCHING 2');

      _commentsData = await FirebaseFirestore.instance
          .collection('forums')
          .doc('posts')
          .collection('posts')
          .doc(documentID)
          .collection('replies')
          .orderBy('timestamp', descending: true)
          .limit(2)
          .get()
          .then((_) => _.docs);
    }

    print('156 : ${_commentsData.toString()}');

    return _commentsData;
  }

  static void toggleUpvote({String userID, String postID, bool isVoted}) async {
    // UNLIKE
    if (isVoted) {
      await FirebaseFirestore.instance
          .collection('forums')
          .doc('posts')
          .collection('posts')
          .doc(postID)
          .collection('upvotes')
          .doc(userID)
          .delete();

      await FirebaseFirestore.instance
          .collection('forums')
          .doc('posts')
          .collection('posts')
          .doc(postID)
          .update({'upvotes_count': FieldValue.increment(-1)});
    }
    // UPVOTE
    else {
      await FirebaseFirestore.instance
          .collection('forums')
          .doc('posts')
          .collection('posts')
          .doc(postID)
          .collection('upvotes')
          .doc(userID)
          .set({'user_id': userID});

      await FirebaseFirestore.instance
          .collection('forums')
          .doc('posts')
          .collection('posts')
          .doc(postID)
          .update({'upvotes_count': FieldValue.increment(1)});
    }
  }

  static void resetInteractions() {
    likesMap = {};
    commentsMap = {};
  }
}
