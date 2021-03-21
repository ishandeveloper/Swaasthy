class PostUserModel {
  final String username;
  final String userimage;
  final String userID;

  PostUserModel({this.userID, this.userimage, this.username});

  factory PostUserModel.getUser(Map<String, dynamic> userData) {
    return PostUserModel(
        userID: userData['user_id'],
        username: userData['user_name'],
        userimage: userData['user_image']);
  }
}
