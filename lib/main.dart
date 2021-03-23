import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codered/screens/auth/signup/signup.dart';
import 'models/user.dart' as usr;
import 'package:codered/services/signup_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:codered/services/index.dart';
import 'package:provider/provider.dart';

import 'screens/index.dart';
import 'utils/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CodeRedApp());
}

class CodeRedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<ConnectionStatus>(
            initialData: null,
            create: (_) => ConnectionService().connectioncontroller.stream),
        ChangeNotifierProvider(create: (_) => RepliesService()),
        ChangeNotifierProvider(create: (_) => UpvotesService()),
        ChangeNotifierProvider(create: (_) => ScreensWrapperService())
        ChangeNotifierProvider(create: (_) => SignUpService())
      ],
      child: GestureDetector(
        onTap: () {
          final FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: MaterialApp(
          title: 'Code Red',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: CodeRedRouter.generateRoute,
          navigatorKey: CodeRedKeys.navigatorKey,
          theme: ThemeData(
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder()
              }),
              textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: 'ProductSans', displayColor: Color(0xff2A2A2A))),
          home: StreamBuilder<Widget>(
              stream: checkUserExistance(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // if (snapshot.data != null) {
                    return snapshot.data;
                  // }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }

  Stream<Widget> checkUserExistance() {
    FirebaseAuth.instance.userChanges().listen((authUser) async {
      if (authUser != null) {
        CollectionReference collectionReference =
            FirebaseFirestore.instance.collection('users');

        final DocumentSnapshot value =
            await collectionReference.doc(authUser.uid).get();
        if (value.exists)
          return ScreensWrapper();
        else {
          usr.User user =
              usr.User(points: 0, email: authUser.email, uid: authUser.uid);
          // collectionReference.doc(authUser.uid).set(user.toJson());
          return SignUp();
        }
      }
      return LoginPage();
    });
  }
}
