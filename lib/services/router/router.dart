/* 
  Router for the Material Application
*/
import '../../screens/auth/signup/signup.dart';
import '../../screens/reminder/new.dart';
import 'package:flutter/material.dart';

import '../../screens/index.dart';
import '../../screens/auth/login.dart';
import 'routes.dart';

class CodeRedRouter {
  static Route<dynamic> generateRoute(RouteSettings routesettings) {
    switch (routesettings.name) {
      case CodeRedRoutes.home:
        return MaterialPageRoute(builder: (_) => ScreensWrapper());
      case CodeRedRoutes.splash:
        return MaterialPageRoute(builder: (_) => const Scaffold());
      case CodeRedRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case CodeRedRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignUp());
      case CodeRedRoutes.emergency:
        return MaterialPageRoute(builder: (_) => const EmergencyScreen());
      case CodeRedRoutes.reminder:
        return MaterialPageRoute(builder: (_) => const MedicineReminder());
      case CodeRedRoutes.firstaid:
        return MaterialPageRoute(builder: (_) => const FirstAidSteps());
      case CodeRedRoutes.newpost:
        return MaterialPageRoute(builder: (_) => const NewForumPost());
      case CodeRedRoutes.bookdoctor:
        return MaterialPageRoute(builder: (_) => const BookAppointment());
      case CodeRedRoutes.medicineReminder:
        return MaterialPageRoute(builder: (_) => const NewReminder());
      default:
        return MaterialPageRoute(builder: (_) => ScreensWrapper());
    }
  }
}
