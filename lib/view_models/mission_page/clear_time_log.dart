import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/main.dart';
import 'package:target_photo_dash/states/states.dart';

class ClearTimeLogStateNotifier extends StateNotifier<ClearTimeLogState> {
  ClearTimeLogStateNotifier(this.ref) : super(const ClearTimeLogState());
  final Ref ref;

  void logClearTime() {
    final missionTerm = ref.read(missionPageProvider).missionTerm;
    final isClear = ref.read(missionResultProvider).clearFlg;
    final restTime = ref.read(tempTimerProvider).restTime;
    List<int> clearTimeList = List<int>.from(state.clearTimeList);
    if (isClear) {
      clearTimeList[missionTerm] = 30 - restTime;
      state = state.copyWith(clearTimeList);
    }
  }
}
