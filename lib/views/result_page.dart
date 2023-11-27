import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/main.dart';
import 'package:target_photo_dash/themes/app_theme.dart';

class ResultView extends ConsumerWidget {
  const ResultView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(scoreStateProvider).score;
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
          const Text("Your Score is ...", style: AppTheme.headline),
          Text("${score.toString()} / 3", style: AppTheme.display1),
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
