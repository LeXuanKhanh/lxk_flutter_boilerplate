// routes for the app
import 'package:flutter/material.dart';
import '/src/screens/animal/animal_detail_screen.dart';
import '/src/screens/home/index.dart';
import '/src/screens/onboarding/authentication_screen.dart';
import '/src/splash_screen.dart';

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
  animalDetail;

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
    <String, MaterialPageRoute<dynamic> Function(RouteSettings)>{
  RouteName.splashScreen.path: (RouteSettings s) =>
      MaterialPageRoute(builder: (_) => const SplashScreen(), settings: s),
  RouteName.home.path: (RouteSettings s) =>
      MaterialPageRoute(builder: (_) => HomeScreen(), settings: s),
  RouteName.auth.path: (RouteSettings s) => MaterialPageRoute(
      builder: (_) => const AuthenticationScreen(), settings: s),
  RouteName.animalDetail.path: (RouteSettings s) => MaterialPageRoute(
      builder: (_) => const AnimalDetailScreen(), settings: s),
};