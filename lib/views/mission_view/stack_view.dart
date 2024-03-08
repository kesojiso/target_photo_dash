import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/models/image_process.dart';
import 'package:target_photo_dash/themes/app_theme.dart';
import 'package:target_photo_dash/views/mission_view/mission_view.dart';

class StackContainer extends ConsumerWidget {
  const StackContainer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePickState = ref.watch(imageProcessStateProvider);
    final filePath = imagePickState.imagePath;
    final screenSize = MediaQuery.of(context).size;
    if (filePath != "") {
      return Container(
        padding: const EdgeInsets.all(20),
        width: screenSize.width,
        height: screenSize.height - 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.file(
              File(filePath),
              fit: BoxFit.fill,
            ),
            Container(
              margin: const EdgeInsets.all(30),
              color: Colors.white.withOpacity(0.5),
              child: const Column(
                children: [
                  TaskResultWidget(),
                  ShowInferLabelWidget(),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return const Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child: Text(
                "Take this photo!!",
                style: AppTheme.headline,
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: TargetWordTextWidget()),
        ],
      );
    }
  }
}

class TaskResultWidget extends ConsumerWidget {
  const TaskResultWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionResultState = ref.watch(imageProcessStateProvider);
    final clearFlg = missionResultState.isMissionClear;
    if (clearFlg) {
      return const Text(
        "OK",
        style: TextStyle(
            fontSize: 40, fontWeight: FontWeight.bold, color: Colors.green),
      );
    } else {
      return const Text(
        "NG",
        style: TextStyle(
            fontSize: 40, fontWeight: FontWeight.bold, color: Colors.red),
      );
    }
  }
}

class ShowInferLabelWidget extends ConsumerWidget {
  const ShowInferLabelWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = ref.watch(imageProcessStateProvider).imageLabels;
    if (labels.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          itemCount: labels.length,
          itemBuilder: (BuildContext context, index) {
            return Center(
              child: Text(
                '${labels[index].label} - ${labels[index].confidence.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }
}
