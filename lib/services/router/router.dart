/* 
  Router for the Material Application
*/
import "package:flutter/material.dart";

import 'package:codered/screens/index.dart';
import 'routes.dart';

class CodeRedRouter {
  static Route<dynamic> generateRoute(RouteSettings routesettings) {
    switch (routesettings.name) {
      case CodeRedRoutes.home:
        return MaterialPageRoute(builder: (_) => ScreensWrapper());
      case CodeRedRoutes.splash:
        return MaterialPageRoute(builder: (_) => Scaffold());
      case CodeRedRoutes.login:
        return MaterialPageRoute(builder: (_) => Scaffold());
      case CodeRedRoutes.emergency:
        return MaterialPageRoute(builder: (_) => EmergencyScreen());
      case CodeRedRoutes.reminder:
        return MaterialPageRoute(builder: (_) => MedicineReminder());
      case CodeRedRoutes.firstaid:
        return MaterialPageRoute(builder: (_) => FirstAidSteps());
      case CodeRedRoutes.newpost:
        return MaterialPageRoute(builder: (_) => NewForumPost());
      default:
        return MaterialPageRoute(builder: (_) => ScreensWrapper());
    }
  }
}
