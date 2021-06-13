import 'models/medicine_reminder.dart';
import 'screens/indicator.dart';
import 'services/apimedic_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'services/user_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/received_notification.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'services/index.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

import 'screens/index.dart';
import 'utils/index.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background,
  // such as Firestore, make sure you call `initializeApp`
  // before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _configureLocalTimeZone();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  const initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  const initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    if (FirebaseAuth.instance.currentUser != null) {
      UserService().increaseUserHeartPoints(10);
    }
  });
  runApp(const CodeRedApp());
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  const timeZoneName = 'Asia/Kolkata';
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

class CodeRedApp extends StatelessWidget {
  const CodeRedApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<ConnectionStatus>(
            initialData: null,
            create: (_) => ConnectionService().connectioncontroller.stream),
        ChangeNotifierProvider(create: (_) => RepliesService()),
        ChangeNotifierProvider(create: (_) => UpvotesService()),
        ChangeNotifierProvider(create: (_) => ScreensWrapperService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => MedicineReminderService()),
        ChangeNotifierProvider(create: (_) => ApiMedicService())
      ],
      child: GestureDetector(
        onTap: () {
          final currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: MaterialApp(
          title: 'Swaasthy',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: CodeRedRouter.generateRoute,
          navigatorKey: CodeRedKeys.navigatorKey,
          theme: ThemeData(
              pageTransitionsTheme: const PageTransitionsTheme(builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder()
              }),
              textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: 'ProductSans',
                  displayColor: const Color(0xff2A2A2A))),
          home: StreamBuilder<User>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final user = snapshot.data;
                  if (user != null) {
                    return Indicator(
                      authUser: user,
                    );
                  }
                  return const LoginPage();
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }
}
