import 'package:flutter/material.dart';
import 'package:target_photo_dash/views/homepage.dart';
import 'package:target_photo_dash/views/playsitepage.dart';
import 'package:target_photo_dash/views/areyouready.dart';
import 'package:target_photo_dash/views/mission_view.dart';

void main() {
  runApp(const MainApp());
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: title, version: version),
        routes: <String, WidgetBuilder>{
          "/home": (BuildContext context) =>
              const MyHomePage(title: title, version: version),
          "/single_play": (BuildContext context) => const PlaySitePage(),
          "/are_you_ready": (BuildContext context) => const AreYouReady(),
          "/mission_view": (BuildContext context) => const CameraLoading(),
          //"/display_picture":(BuildContext context) => DisplayPicture(imagePath: imagePath),
          // "/multi_play": (BuildContext context) => const MultiPlay(),
        });
  }
}
