import 'package:flutter/services.dart';
import 'dart:math';

Future<List<String>> getMissionWordsList() async {
  final labels = await rootBundle.loadString("assets/labels.txt");
  final labelsList = labels.split("\n");
  final random = Random();
  final List<String> shuffleList = List.of(labelsList)..shuffle(random);
  final List<String> pickedList = shuffleList.take(3).toList();
  return pickedList;
}

bool judgeItems({List? labels, required String missionLabel}) {
  if (labels == null) {
    return false;
  } else if (labels.contains(missionLabel)) {
    return true;
  } else {
    return false;
  }
}
