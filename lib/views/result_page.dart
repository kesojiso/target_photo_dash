import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/models/mission_result_logic.dart';
import 'package:target_photo_dash/models/get_target_words_list.dart';
import 'package:target_photo_dash/themes/app_theme.dart';

int calcScore(WidgetRef ref) {
  List<bool> scoreList = ref.read(resultStateProvider).scoreList;
  return scoreList.where((value) => value == true).length;
}

class ResultView extends ConsumerWidget {
  const ResultView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = calcScore(ref);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text("Your Score is ...", style: AppTheme.headline),
                    const SizedBox(height: 20),
                    Text("${score.toString()} / 3", style: AppTheme.display1),
                  ],
                ),
              ),
              const ResultCards(),
              Padding(
                padding: const EdgeInsets.all(20.0),
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
                    ref.invalidate(resultStateProvider);
                  },
                  child: const Center(
                    child: Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultCards extends ConsumerWidget {
  const ResultCards({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetWordList = ref.watch(targetWordListProvider).pickedList;
    final storeImgPathList = ref.watch(resultStateProvider).imagePathList;
    final scoreList = ref.watch(resultStateProvider).scoreList;
    final clearTimeList = ref.watch(resultStateProvider).clearTimeList;
    return Expanded(
      child: ListView.builder(
        itemCount: targetWordList.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(targetWordList[index],
                    style: const TextStyle(fontSize: 30)),
                scoreList[index]
                    ? const Text("OK!",
                        style: TextStyle(color: Colors.green, fontSize: 30))
                    : const Text(
                        "NG",
                        style: TextStyle(color: Colors.red, fontSize: 30),
                      ),
                Text(
                  clearTimeList[index] != -1
                      ? "${clearTimeList[index]} sec"
                      : "- sec",
                  style: AppTheme.headline,
                ),
                storeImgPathList[index] != ""
                    ? Image.file(File(storeImgPathList[0]))
                    : const Text("No Image"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
