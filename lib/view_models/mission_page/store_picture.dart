import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/main.dart';
import 'package:target_photo_dash/states/states.dart';

class StoreImgPathStateNotifier extends StateNotifier<StoreImgPathState> {
  StoreImgPathStateNotifier(this.ref) : super(const StoreImgPathState());
  final Ref ref;

  void addImage() async {
    final missionTerm = ref.read(missionPageProvider).missionTerm;
    final isClear = ref.read(missionResultProvider).clearFlg;
    final scoreList = ref.read(scoreStateProvider).scoreList;
    final filePath = ref.read(imagePickProvider).filePath;
    final List<String> storeImgPathList =
        List<String>.from(state.storeImgPathList);
    if (isClear) {
      //ミッションクリアの場合は写真を入れ替える
      storeImgPathList[missionTerm] = filePath;
      state = state.copyWith(storeImgPathList);
    } else {
      if (scoreList[missionTerm] == false) {
        //ミッション失敗&過去にクリア実績なしの場合は写真を入れ替える
        storeImgPathList[missionTerm] = filePath;
        state = state.copyWith(storeImgPathList);
      }
    }
  }
}
