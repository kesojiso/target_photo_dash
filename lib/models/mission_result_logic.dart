import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/models/image_process.dart';
import 'package:target_photo_dash/view_models/mission_page/mission_term_vm.dart';
import 'package:target_photo_dash/view_models/mission_page/temp_timer.dart';

class ResultState {
  List<bool> scoreList;
  List<int> clearTimeList;
  List<String> imagePathList;
  ResultState(
      {this.scoreList = const [false, false, false],
      this.clearTimeList = const [-1, -1, -1],
      this.imagePathList = const ["", "", ""]});
  ResultState copyWith(
          {List<bool>? scoreList,
          List<int>? clearTimeList,
          List<String>? imagePathList}) =>
      ResultState(
          scoreList: scoreList ?? this.scoreList,
          clearTimeList: clearTimeList ?? this.clearTimeList,
          imagePathList: imagePathList ?? this.imagePathList);
}

class ResultStateNotifier extends StateNotifier<ResultState> {
  final Ref ref;
  ResultStateNotifier(this.ref) : super(ResultState());
  void updateResult() {
    int missionTerm = ref.read(missionTermProvider).missionTerm;
    bool isClear = ref.read(imageProcessStateProvider).isMissionClear;
    int clearTime = ref.read(tempTimerProvider).timer;
    String imagePath = ref.read(imageProcessStateProvider).imagePath;
    List<bool> scoreList = List<bool>.from(state.scoreList);
    List<int> clearTimeList = List<int>.from(state.clearTimeList);
    List<String> imagePathList = List<String>.from(state.imagePathList);

    if (isClear) {
      if (scoreList[missionTerm]) {
        //ミッション成功&過去にクリア実績ありの場合
        imagePathList[missionTerm] = imagePath;
      } else {
        //ミッション成功&過去にクリア実績なしの場合
        scoreList[missionTerm] = true;
        clearTimeList[missionTerm] = clearTime;
        imagePathList[missionTerm] = imagePath;
      }
    } else {
      if (scoreList[missionTerm] == false) {
        //ミッション失敗&過去にクリア実績なしの場合
        imagePathList[missionTerm] = imagePath;
      }
    }

    state = state.copyWith(
      scoreList: scoreList,
      clearTimeList: clearTimeList,
      imagePathList: imagePathList,
    );
  }
}

final resultStateProvider =
    StateNotifierProvider<ResultStateNotifier, ResultState>(
  (ref) => ResultStateNotifier(ref),
);
