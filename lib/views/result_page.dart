import 'dart:io';
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
                    ref.invalidate(scoreStateProvider);
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

class DisplayResultImage extends ConsumerWidget {
  const DisplayResultImage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeImgPathList =
        ref.watch(storeImageStateProvider).storeImgPathList;
    return Center(
      child: Table(
        border: TableBorder.all(),
        children: [
          const TableRow(children: [
            Center(child: Text("1")),
            Center(child: Text("2")),
            Center(child: Text("3")),
          ]),
          TableRow(children: [
            Center(
                child: storeImgPathList[0] != ""
                    ? Image.file(File(storeImgPathList[0]))
                    : const Text("No Image")),
            Center(
                child: storeImgPathList[1] != ""
                    ? Image.file(File(storeImgPathList[1]))
                    : const Text("No Image")),
            Center(
                child: storeImgPathList[2] != ""
                    ? Image.file(File(storeImgPathList[2]))
                    : const Text("No Image")),
          ])
        ],
      ),
    );
  }
}
