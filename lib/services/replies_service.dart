/*
  This service is responsible for keeping track of comments for all the 
  different posts in the list
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codered/models/index.dart';
import 'package:flutter/material.dart';

class RepliesService with ChangeNotifier {
  // int _max = 0;
  // List<List<ReplyModel>> _comments = [];
  Map<int?, List<ReplyModel>> _comments = {};
  Map<int?, int?> _commentsCount = {};
  Map<int?, DocumentSnapshot?> _lastDocument = {};

  void addCommentList(comments, int? index) {
    var _tempComments = [];
    for (var comment in comments) {
      _tempComments.add(ReplyModel.getModel(comment.data(), comment.id));
    }
    _tempComments = List<ReplyModel>.from(_tempComments);

    // if (!_comments.containsKey(index)) {
    _comments.addAll({index: _tempComments as List<ReplyModel>});
    // }

    notifyListeners();
  }

  // void resetComments() => _comments = [];

  List<ReplyModel>? getComments({required int? index}) {
    if (_comments[index] == null) return [];

    return _comments[index];
  }

  void updateComment({required int? index, required ReplyModel comment}) {
    print("UPDATE COMMENT CALLED");

    if (_comments[index] != null) {
      _comments[index]!.insert(0, comment);
    } else {
      _comments[index] = [comment];
    }

    addCommentsCount(index);

    notifyListeners();
  }

  void updateCommentText({
    required int index,
    required String text,
    required String commentID,
  }) {
    int _index = _comments[index]!.indexWhere((e) => e.docID == commentID);

    ReplyModel _tempModel = _comments[index]![_index];

    ReplyModel _newModel = ReplyModel.getModel({
      'body': text,
      'user': {
        'user_name': _tempModel.user!.username,
        'user_id': _tempModel.user!.userID,
        'user_image': _tempModel.user!.userimage
      },
      'timestamp': _tempModel.timestamp,
    }, _tempModel.docID);

    _comments[index]![_index] = _newModel;

    notifyListeners();
  }

  void deleteComment({required int postIndex, required ReplyModel comment}) {
    _comments[postIndex]!.remove(comment);
    // _comments[postIndex]
    //     .removeWhere((element) => element.docID == comment.docID);

    notifyListeners();
  }

  void updateCommentsList({required int? index, required comments}) {
    List<ReplyModel> _tempComments = [];
    for (var comment in comments) {
      _tempComments.add(ReplyModel.getModel(comment.data(), comment.id));
    }
    _comments[index]!.insertAll(
        _comments[index]!.indexOf(_comments[index]!.last) + 1, _tempComments);

    notifyListeners();
  }

  void assignCommentsCount(int index, int? count) {
    _commentsCount.addAll({index: count});

    notifyListeners();
  }

  void addCommentsCount(int? index) {
    print("UPDATE COMMENT COUNT CALLED");

    _commentsCount[index] = _commentsCount[index]! + 1;
    notifyListeners();
  }

  void deleteCommentsCount(int index) {
    _commentsCount[index] = _commentsCount[index]! - 1;
    notifyListeners();
  }

  int? getCommentsCount(int? index) {
    if (_commentsCount[index] == null) return 0;
    return _commentsCount[index];
  }

  void assignLastDocument(int? index, DocumentSnapshot last) {
    if (_lastDocument.containsKey(index)) {
      _lastDocument[index] = last;
    } else {
      _lastDocument.addAll({index: last});
    }

    notifyListeners();
  }

  DocumentSnapshot? getLastDocument(int? index) {
    if (_lastDocument.containsKey(index)) return _lastDocument[index];

    return null;
  }

  void resetLastDocument(int index) {
    if (_lastDocument.containsKey(index)) _lastDocument[index] = null;
  }
}
