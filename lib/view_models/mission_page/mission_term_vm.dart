import 'package:flutter_riverpod/flutter_riverpod.dart';

class MissionTermState {
  final int missionTerm;
  const MissionTermState({this.missionTerm = 0});
  MissionTermState copyWith(int missionTerm) =>
      MissionTermState(missionTerm: missionTerm);
}

class MissionTermStateNotifier extends StateNotifier<MissionTermState> {
  MissionTermStateNotifier() : super(const MissionTermState());

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

final missionTermProvider =
    StateNotifierProvider<MissionTermStateNotifier, MissionTermState>(
        (ref) => MissionTermStateNotifier());
