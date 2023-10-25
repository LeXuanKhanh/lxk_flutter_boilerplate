import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:lxk_flutter_boilerplate/shared/index.dart';
import 'package:lxk_flutter_boilerplate/src/routes/nav_observer.dart';
import 'package:lxk_flutter_boilerplate/src/routes/index.dart';
import 'package:lxk_flutter_boilerplate/src/utils/app_state_notifier.dart';
import 'package:lxk_flutter_boilerplate/src/config/theme_data.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext get globalContext => navigatorKey.currentContext!;
final _navObserver = NavObserver();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(builder: (context, appState, child) {
      return MultiBlocProvider(
        providers: blocProviders,
        child: GlobalLoaderOverlay(
          overlayColor: Colors.black.withOpacity(0.6),
          // duration: const Duration(milliseconds: 300),
          // reverseDuration: const Duration(milliseconds: 300),
          // switchInCurve: Curves.easeIn,
          // switchOutCurve: Curves.easeOut,
          child: MaterialApp(
            title: 'News!',
            theme: ThemeConfig.lightTheme,
            darkTheme: ThemeConfig.darkTheme,
            themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            navigatorKey: navigatorKey,
            navigatorObservers: [_navObserver],
            onGenerateRoute: routes,
          ),
        ),
      );
    });
  }
}
