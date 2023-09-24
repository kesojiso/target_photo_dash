import 'package:flutter/material.dart';
import 'package:target_photo_dash/themes/app_theme.dart';

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
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
          const Text("Your Score is ...", style: AppTheme.headline),
          Text("${scoreCalculator(scoreList).toString()} / 3",
              style: AppTheme.display1),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 10,
                      fixedSize: const Size(200, 70),
                      backgroundColor: AppTheme.nearlyBlack),
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
