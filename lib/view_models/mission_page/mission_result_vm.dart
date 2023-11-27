import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/main.dart';
import 'package:target_photo_dash/states/states.dart';

class ScoreStateNotifier extends StateNotifier<ScoreState> {
  ScoreStateNotifier(this.ref) : super(const ScoreState());
  final Ref ref;

  void updateScore() {
    final missionTerm = ref.watch(missionPageProvider).missionTerm;
    final isClear = ref.watch(missionResultProvider).clearFlg;
    final scoreList = ref.watch(scoreStateProvider).scoreList;
    if (isClear) {
      scoreList[missionTerm] = true;
    }
    final score = scoreList.where((value) => value == true).length;
    state = state.copyWith(scoreList: scoreList, score: score);
  }
}
