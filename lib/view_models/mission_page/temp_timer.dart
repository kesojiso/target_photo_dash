import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TempTimerState {
  const TempTimerState({this.timer = 0});
  final int timer;
  TempTimerState copyWith(int timer) => TempTimerState(timer: timer);
}

class TempTimerStateNotifier extends StateNotifier<TempTimerState> {
  Timer? _timer;
  TempTimerStateNotifier(this.ref) : super(const TempTimerState());
  final Ref ref;

  void startTimer(int duration) {
    state = state.copyWith(0);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timer == duration) {
        _timer?.cancel();
      } else {
        state = state.copyWith(state.timer + 1);
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final tempTimerProvider =
    StateNotifierProvider<TempTimerStateNotifier, TempTimerState>(
        (ref) => TempTimerStateNotifier(ref));
