import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/models/mission_result_logic.dart';
import 'package:target_photo_dash/models/get_target_words_list.dart';
import 'package:target_photo_dash/themes/app_theme.dart';

class ResultView extends ConsumerWidget {
  const ResultView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = calcScore(ref);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Your Score is ...", style: AppTheme.headline),
            Text("${score.toString()} / 3", style: AppTheme.display1),
            const DisplayResultImage(),
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
    );
  }
}

class DisplayResultImage extends ConsumerWidget {
  const DisplayResultImage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetWordList = ref.watch(targetWordListProvider).pickedList;
    final storeImgPathList = ref.watch(resultStateProvider).imagePathList;
    final scoreList = ref.watch(resultStateProvider).scoreList;
    final clearTimeList = ref.watch(resultStateProvider).clearTimeList;
    return Center(
      child: Table(
        border: TableBorder.all(),
        children: [
          TableRow(
            children: List.generate(
              targetWordList.length,
              (index) => Center(
                child: Text(targetWordList[index], style: AppTheme.headline),
              ),
            ),
          ),
          TableRow(
            children: List.generate(
              scoreList.length,
              (index) => Center(
                child: scoreList[index]
                    ? const Text("OK!",
                        style: TextStyle(color: Colors.green, fontSize: 30))
                    : const Text(
                        "NG",
                        style: TextStyle(color: Colors.red, fontSize: 30),
                      ),
              ),
            ),
          ),
          TableRow(
            children: List.generate(
              clearTimeList.length,
              (index) => Center(
                child: Text(
                  clearTimeList[index] != -1
                      ? "${clearTimeList[index]} sec"
                      : "- sec",
                  style: AppTheme.headline,
                ),
              ),
            ),
          ),
          TableRow(
            children: List.generate(
              storeImgPathList.length,
              (index) => Center(
                child: storeImgPathList[index] != ""
                    ? Image.file(File(storeImgPathList[index]))
                    : const Text("No Image"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

int calcScore(WidgetRef ref) {
  List<bool> scoreList = ref.read(resultStateProvider).scoreList;
  return scoreList.where((value) => value == true).length;
}
