/*
  This service is responsible for keeping track of likes for all the 
  different posts in the list
*/

import 'package:flutter/material.dart';

class UpvotesService with ChangeNotifier {
  Map<int, List<String?>> _likes = {};

  void addLikesToList(List<String?> likes, int index) {
    if (!_likes.containsKey(index)) {
      _likes.addAll({index: likes});
    }

    notifyListeners();
  }

  List<String?>? getLikes({required int? index}) {
    if (_likes[index!] == null) return [];

    return _likes[index];
  }

  void updateLike({required int? index, required String? uid}) {
    print("UPDATE LIKE CALLED");
    if (_likes[index!]!.contains(uid)) {
      _likes[index]!.remove(uid);
    } else {
      _likes[index]!.add(uid);
    }

    notifyListeners();
  }
}
