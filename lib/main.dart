import '/src/app.dart';
import '/src/utils/app_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
      create: (_) => AppStateNotifier(),
      child: const App(),
    ),
  );
}
