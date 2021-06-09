import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser =
        await (GoogleSignIn().signIn() as Future<GoogleSignInAccount>);

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    ) as GoogleAuthCredential;

    var authUser = await FirebaseAuth.instance.signInWithCredential(credential);

    // if (authUser != null) {
    //   CollectionReference collectionReference =
    //       FirebaseFirestore.instance.collection('users');

    //   QuerySnapshot querySnapshot = await collectionReference.get();

    //   querySnapshot.docs.map((e) async {
    //     if (e.id == authUser.user.uid)
    //       return authUser;
    //     else {
    //       usr.User user = usr.User(
    //           points: 0, email: authUser.user.email, uid: authUser.user.uid);
    //       await collectionReference.doc(authUser.user.uid).set(user.toJson());
    //       return CodeRedKeys.navigatorKey.currentState
    //           .pushNamedAndRemoveUntil(CodeRedRoutes.signup, (route) => false);
    //     }
    //   });
    // }

    // Once signed in, return the UserCredential
    return authUser;
  }

  static Future<void> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }
}
