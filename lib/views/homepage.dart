import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title, required this.version});
  final String title;
  final String version;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("HomePage"),
        ),
        body: Center(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold)),
            ),
            Image.asset("assets/pic_target_photo_dash_home.png"),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/single_play");
                    },
                    child: const Center(
                        child: Text("Single Play",
                            style: TextStyle(fontSize: 30))))),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/multi_play");
                  },
                  child: const Center(
                      child:
                          Text("Multi Play", style: TextStyle(fontSize: 30))),
                ))
          ],
        )));
  }
}
