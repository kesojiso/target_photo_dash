import 'package:flutter/material.dart';
import 'package:target_photo_dash/models/app_theme.dart';

class ResultView extends StatelessWidget {
  final List<bool> scoreList;
  const ResultView({super.key, required this.scoreList});

  int scoreCalculator(List scoreList) {
    int score = scoreList.where((value) => value == true).length;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //   title: const Text("Result"),
        // ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
          const Text("Your Score is ...", style: TextStyle(fontSize: 30)),
          Text("${scoreCalculator(scoreList).toString()}/3",
              style: Theme.of(context).textTheme.headlineLarge),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 70),
                      backgroundColor: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      "/home",
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Center(
                      child: Text("Home",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ))))),
        ])));
  }
}
