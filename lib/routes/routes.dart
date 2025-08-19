import 'package:flutter/material.dart';
import 'router.dart';
import '../ui/main_screen/main_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.mainScreen:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      default:
        return MaterialPageRoute(builder: (_) => const MainScreen());
    }
  }
}