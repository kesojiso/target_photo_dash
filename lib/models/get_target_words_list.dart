import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TargetWordsList
class TargetWordsListState {
  const TargetWordsListState({this.pickedList = const []});
  final List<String> pickedList;
  TargetWordsListState copyWith(List<String> pickedList) =>
      TargetWordsListState(pickedList: pickedList);
}

class TargetWordsListNotifier extends StateNotifier<TargetWordsListState> {
  TargetWordsListNotifier() : super(const TargetWordsListState());

  Future getTargetWordsList() async {
    final labels = await rootBundle.loadString("assets/target_labels.txt");
    final labelsList = labels.split("\n");
    final random = Random();
    final List<String> shuffleList = List.of(labelsList)..shuffle(random);
    final List<String> pickedList = shuffleList.take(3).toList();
    state = state.copyWith(pickedList);
  }
}

final targetWordListProvider =
    StateNotifierProvider<TargetWordsListNotifier, TargetWordsListState>(
        (ref) => TargetWordsListNotifier());
