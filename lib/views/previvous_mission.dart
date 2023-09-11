import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class PreviousMissionPage extends StatelessWidget {
  PreviousMissionPage({super.key});
  final missionWordsController = StreamController<Future<List<String>>>();
  Stream get dataStream => missionWordsController.stream;
  void shareMissionWords() {
    final pickedList = pick3Words();
    missionWordsController.sink.add(pickedList);
  }

  Future<List<String>> pick3Words() async {
    final labels = await rootBundle.loadString("assets/labels.txt");
    final labelsList = labels.split("\n");
    final random = Random();
    final List<String> shuffleList = List.of(labelsList)..shuffle(random);
    final List<String> pickedList = shuffleList.take(3).toList();
    return pickedList;
  }

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
                          shareMissionWords();
                          Navigator.of(context).pushNamed("/mission_view");
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
