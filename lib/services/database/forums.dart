import 'package:cloud_firestore/cloud_firestore.dart';

class ForumsHelper {
  static Future<List<QueryDocumentSnapshot>> getPosts() async {
    return await FirebaseFirestore.instance
        .collection('forums')
        .doc('posts')
        .collection('posts')
        .get()
        .then((data) {
      List<QueryDocumentSnapshot> _posts = data.docs;

      print(_posts[0]);

      return _posts;
    });
  }
}
