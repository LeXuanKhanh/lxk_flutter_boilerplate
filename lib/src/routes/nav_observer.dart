import 'package:flutter/material.dart';

class NavObserver extends NavigatorObserver {
  NavObserver._();
  static final NavObserver _instance = NavObserver._();
  factory NavObserver() => _instance;

  List<Route<dynamic>> routeStack = [];
  List<String?> get routePath  {
    return routeStack.map((e) => e.settings.name).toList();
}
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // print('observer push ${route}');
    routeStack.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.removeLast();
  }


  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.removeLast();
  }

  @override
  void didReplace({ Route<dynamic>? newRoute, Route<dynamic>? oldRoute }) {
    routeStack.removeLast();
    routeStack.add(newRoute!);
  }
}