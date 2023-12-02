import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/main.dart';
import 'package:target_photo_dash/states/states.dart';

class MissionResultNotifier extends StateNotifier<MissionResultState> {
  MissionResultNotifier(this.ref) : super(const MissionResultState());
  final Ref ref;

  bool judgeInclusion() {
    final targetWordList = ref.read(targetWordListProvider).pickedList;
    final missionTerm = ref.read(missionPageProvider).missionTerm;
    final targetWord = targetWordList[missionTerm];
    final labels = ref.read(inferenceProvider).labels;
    String labelReplaced;
    String targetWordReplaced;
    if (labels.isEmpty) {
      state = state.copyWith(false);
      return false;
    }
    for (var label in labels) {
      labelReplaced = label.label.replaceAll(RegExp(r'\s'), '');
      targetWordReplaced = targetWord.replaceAll(RegExp(r'\s'), '');
      if (labelReplaced == targetWordReplaced) {
        state = state.copyWith(true);
        return true;
      }
    }
    state = state.copyWith(false);
    return false;
  }
}
