import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/states/states.dart';

class TempTimerStateNotifier extends StateNotifier<TempTimerState> {
  Timer? _timer;
  TempTimerStateNotifier(this.ref) : super(const TempTimerState());
  final Ref ref;

  void startTimer(int duration) {
    state = state.copyWith(duration);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.restTime == 0) {
        _timer?.cancel();
      } else {
        state = state.copyWith(state.restTime - 1);
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
