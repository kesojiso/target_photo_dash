import 'package:flutter/services.dart';
import 'dart:math';

Future<List<String>> getTargetWordsList() async {
  final labels = await rootBundle.loadString("assets/labels.txt");
  final labelsList = labels.split("\n");
  final random = Random();
  final List<String> shuffleList = List.of(labelsList)..shuffle(random);
  final List<String> pickedList = shuffleList.take(3).toList();
  return pickedList;
}

bool judgeItemsInclusion({List? labels, required String targetWord}) {
  String labelReplaced;
  String targetWordReplaced;
  if (labels == null) {
    return false;
  }
  for (var label in labels) {
    labelReplaced = label.label.replaceAll(RegExp(r'\s'), '');
    targetWordReplaced = targetWord.replaceAll(RegExp(r'\s'), '');
    if (labelReplaced == targetWordReplaced) {
      return true;
    }
  }
  return false;
}
