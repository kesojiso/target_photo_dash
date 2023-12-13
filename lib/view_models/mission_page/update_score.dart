import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/main.dart';
import 'package:target_photo_dash/states/states.dart';

class ScoreStateNotifier extends StateNotifier<ScoreState> {
  ScoreStateNotifier(this.ref) : super(const ScoreState());
  final Ref ref;

  void updateScore() {
    final missionTerm = ref.read(missionPageProvider).missionTerm;
    final isClear = ref.read(missionResultProvider).clearFlg;
    List<bool> scoreList = List<bool>.from(state.scoreList);
    int score;
    if (isClear) {
      scoreList[missionTerm] = true;
      score = scoreList.where((value) => value == true).length;
      state = state.copyWith(scoreList: scoreList, score: score);
    }
  }
}
