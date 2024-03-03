import 'package:target_photo_dash/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:target_photo_dash/views/previvous_mission.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title, required this.version});
  final String title;
  final String version;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(title,
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          ),
          Stack(children: [
            Image.asset("assets/pic_target_photo_dash_home.png"),
            Positioned(
              right: 30,
              top: 0,
              child: FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: AppTheme.nearlyBlack,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Mission'),
                          content: const Text(
                              'We will give you three words, so please take a picture that corresponds to the word.\nWe will judge pass or fail with using image recognition system.'),
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
                  child: const Icon(Icons.question_mark,
                      color: AppTheme.nearlyWhite, size: 40)),
            ),
          ]),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 10,
                          fixedSize: const Size(250, 70),
                          backgroundColor: AppTheme.nearlyBlack),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PreviousMissionPage()));
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
                          elevation: 10,
                          fixedSize: const Size(250, 70),
                          backgroundColor: AppTheme.nearlyBlack),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Not Available'),
                              content: const Text(
                                  'Sorry, this featurer is under development.'),
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
            ]),
          )
        ],
      )),
    ));
  }
}
