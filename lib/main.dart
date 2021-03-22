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

class CodeRedApp extends StatefulWidget {
  @override
  _CodeRedAppState createState() => _CodeRedAppState();
}

class _CodeRedAppState extends State<CodeRedApp> {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');

  QuerySnapshot querySnapshot;
  List<QueryDocumentSnapshot> documents = [];

  @override
  void initState() {
    query();
    super.initState();
  }

  query() async {
    querySnapshot = await collectionReference.get();
    documents = querySnapshot.docs;
    print(documents.length);
  }

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
          home: StreamBuilder<User>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  User authUser = snapshot.data;
                  if (authUser != null) {
                    documents.map((e) async {
                      if (e.id == authUser.uid)
                        return ScreensWrapper();
                      else {
                        usr.User user = usr.User(
                            points: 0,
                            email: authUser.email,
                            uid: authUser.uid);
                        await collectionReference
                            .doc(authUser.uid)
                            .set(user.toJson());
                        return SignUp();
                      }
                    });
                  }
                  return LoginPage();
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }
}
