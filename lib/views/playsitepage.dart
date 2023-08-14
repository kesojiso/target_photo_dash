import 'package:flutter/material.dart';

class PlaySitePage extends StatelessWidget {
  const PlaySitePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Play Site Page"),
        ),
        body: Center(
            child: Column(children: [
          const Text("Select Site", style: TextStyle(fontSize: 30)),
          const Spacer(),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/are_you_ready");
                  },
                  child: const Center(
                      child: Text("Inside Home",
                          style: TextStyle(fontSize: 30))))),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/are_you_ready");
                  },
                  child: const Center(
                      child: Text("Outdoor", style: TextStyle(fontSize: 30)))))
        ])));
  }
}
