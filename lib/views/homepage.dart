import 'package:target_photo_dash/models/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:target_photo_dash/views/previvous_mission.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title, required this.version});
  final String title;
  final String version;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 100, left: 10, right: 10, bottom: 30),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        ),
        Image.asset("assets/pic_target_photo_dash_home.png"),
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(250, 70),
                    backgroundColor: AppTheme.dismissibleBackground),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PreviousMissionPage()));
                },
                child: const Center(
                    child: Text("Single Play",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ))))),
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(250, 70),
                    backgroundColor: AppTheme.dismissibleBackground),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Not Available'),
                        content: const Text(
                            'Sorry, this featurer is under development'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Center(
                    child: Text("Multi Play",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        )))))
      ],
    )));
  }
}
