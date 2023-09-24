import 'package:flutter/material.dart';
import 'package:target_photo_dash/views/homepage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:target_photo_dash/themes/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Target Photo Dash';
    const version = '0.1.0';
    return MaterialApp(
        title: title,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: const Color.fromARGB(255, 245, 236, 177),
          scaffoldBackgroundColor: const Color.fromARGB(255, 243, 232, 198),
          fontFamily: AppTheme.fontName,
          textTheme: AppTheme.textTheme,
        ),
        home: const MyHomePage(title: title, version: version),
        routes: <String, WidgetBuilder>{
          "/home": (BuildContext context) =>
              const MyHomePage(title: title, version: version),
        });
  }
}
