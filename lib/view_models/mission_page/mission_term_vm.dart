import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/states/states.dart';

class MissionPageStateNotifier extends StateNotifier<MissionTermState> {
  MissionPageStateNotifier() : super(const MissionTermState());

  void increment() {
    if (state.missionTerm < 2) {
      state = state.copyWith(state.missionTerm + 1);
    } else {
      state = state.copyWith(state.missionTerm);
    }
  }

  void decrement() {
    if (state.missionTerm > 0) {
      state = state.copyWith(state.missionTerm - 1);
    } else {
      state = state.copyWith(state.missionTerm);
    }
  }
}
