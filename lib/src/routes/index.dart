// routes for the app
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lxk_flutter_boilerplate/src/screens/animal/animal_detail_screen.dart';
import 'package:lxk_flutter_boilerplate/src/screens/home/index.dart';
import 'package:lxk_flutter_boilerplate/src/screens/authentication/authentication_screen.dart';
import 'package:lxk_flutter_boilerplate/src/screens/webview/webview_screen.dart';
import 'package:lxk_flutter_boilerplate/src/splash_screen.dart';

Route routes(RouteSettings settings) {
  final route = _routeConfigMap[settings.name] ??
      (RouteSettings s) =>
          MaterialPageRoute(builder: (_) => const SplashScreen(), settings: s);
  return route(settings);

  // if (settings.name == RouteName.splashScreen.path) {
  //   return MaterialPageRoute(builder: (_) => const SplashScreen(), settings: settings);
  // } else if (settings.name == RouteName.home.path) {
  //   return MaterialPageRoute(builder: (_) => HomeScreen(), settings: settings);
  // } else if (settings.name == RouteName.auth.path) {
  //   return MaterialPageRoute(builder: (_) => const AuthenticationScreen(), settings: settings);
  // } else {
  //   return MaterialPageRoute(builder: (_) => const SplashScreen(), settings: settings);
  // }
}

enum RouteName {
  splashScreen,
  home,
  auth,
  animalDetail,
  webView;

  String get path {
    if (this == RouteName.splashScreen) {
      return '/';
    }

    return '$this'.replaceAll('RouteName.', '/');
  }

  RoutePredicate get modalRoute {
    return ModalRoute.withName(path);
  }
}

final _routeConfigMap =
    <String, PageRoute<dynamic> Function(RouteSettings)>{
  RouteName.splashScreen.path: (RouteSettings s) =>
      MaterialPageRoute(builder: (_) => const SplashScreen(), settings: s),
  RouteName.home.path: (RouteSettings s) =>
      MaterialPageRoute(builder: (_) => HomeScreen(), settings: s),
  RouteName.auth.path: (RouteSettings s) => MaterialPageRoute(
      builder: (_) => const AuthenticationScreen(), settings: s),
  RouteName.animalDetail.path: (RouteSettings s) => MaterialPageRoute(
      builder: (_) => const AnimalDetailScreen(), settings: s),
  RouteName.webView.path: (RouteSettings s) => CupertinoPageRoute(
      fullscreenDialog: true,
      builder: (_) => const WebViewScreen(),
      settings: s),
};
