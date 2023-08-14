import 'package:flutter/material.dart';

class AreYouReady extends StatelessWidget {
  const AreYouReady({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Play Site Page"),
        ),
        body: Center(
            child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text("Are You Ready??", style: TextStyle(fontSize: 30)),
            ),
            const Spacer(),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("/aa");
                        },
                        child: const Center(
                            child:
                                Text("Yes", style: TextStyle(fontSize: 30)))))),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Center(
                            child: Text("Back to Previous Page",
                                style: TextStyle(fontSize: 20))))))
          ],
        )));
  }
}
