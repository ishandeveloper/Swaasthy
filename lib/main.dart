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
      ],
      child: MaterialApp(
        title: 'Code Red',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: CodeRedRouter.generateRoute,
        // initialRoute: '/home',
        theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder()
            }),
            textTheme: Theme.of(context).textTheme.apply(
                fontFamily: 'ProductSans', displayColor: Color(0xff2A2A2A))),
        home: StreamBuilder<User>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.active) {
              // User user = snapshot.data;
              // if (user != null) {
              return ScreensWrapper();
              // }
              // return LoginPage();
              // }
              // return Center(
              //   child: CircularProgressIndicator(),
              // );
            }),
      ),
    );
  }
}
