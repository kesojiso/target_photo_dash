import 'package:flutter/material.dart';
import 'package:target_photo_dash/models/mission_result_logic.dart';
import 'package:target_photo_dash/themes/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/views/mission_view/camera_button.dart';
import 'package:target_photo_dash/views/mission_view/stack_view.dart';
import 'package:target_photo_dash/views/result_page.dart';
import 'package:target_photo_dash/view_models/mission_page/temp_timer.dart';
import 'package:target_photo_dash/models/get_target_words_list.dart';
import 'package:target_photo_dash/view_models/mission_page/mission_term_vm.dart';
import 'package:target_photo_dash/models/image_process.dart';

int calcRestTime({required int duration, required int pasttime}) {
  return duration - pasttime;
}

void wholeImageProcess(WidgetRef ref) async {
  await ref.read(imageProcessStateProvider.notifier).imagePick();
  await ref.read(imageProcessStateProvider.notifier).inference();
  ref.read(imageProcessStateProvider.notifier).judgeInclusion();
  ref.read(resultStateProvider.notifier).updateResult();
}

class MissionPage extends ConsumerWidget {
  const MissionPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Oops!'),
              content: const Text('can not back to previous pages'),
              actions: <Widget>[
                TextButton(
                  child: const Text('close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Target : ", style: AppTheme.title),
              TargetWordTextWidget(),
              Spacer(),
              TimerWidget()
            ],
          ),
        ),
        body: const Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            StackContainer(),
            Spacer(),
            CameraButtonSelectorWidget(),
            NextButtonWidget(),
          ]),
        ),
      ),
    );
  }
}

class TimerWidget extends ConsumerWidget {
  const TimerWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(tempTimerProvider).timer;
    final restTime = calcRestTime(duration: 30, pasttime: timer);
    return Row(children: [
      const Icon(Icons.timer_outlined),
      Text('00:${restTime.toString().padLeft(2, "0")}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    ]);
  }
}

class TargetWordTextWidget extends ConsumerWidget {
  const TargetWordTextWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetWordsListState = ref.watch(targetWordListProvider);
    final missionTermState = ref.watch(missionTermProvider);
    final targetWordsList = targetWordsListState.pickedList;
    final missionTerm = missionTermState.missionTerm;
    if (targetWordsList.isNotEmpty) {
      return Text(targetWordsList[missionTerm], style: AppTheme.headline);
    } else {
      return const CircularProgressIndicator();
    }
  }
}

class NextButtonWidget extends ConsumerWidget {
  const NextButtonWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionTermState = ref.watch(missionTermProvider);
    final missionTermNotifier = ref.watch(missionTermProvider.notifier);
    void finishNavigate() {
      if (missionTermState.missionTerm >= 2) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ResultView()));
        ref.invalidate(missionTermProvider);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 10,
              fixedSize: const Size(300, 70),
              backgroundColor: AppTheme.nearlyBlack),
          onPressed: () {
            missionTermNotifier.increment();
            ref.invalidate(imageProcessStateProvider);
            ref.read(tempTimerProvider.notifier).stopTimer();
            ref.read(tempTimerProvider.notifier).startTimer(30);
            finishNavigate();
          },
          child: Center(
              child: missionTermState.missionTerm < 2
                  ? const Text("Submit",
                      style: TextStyle(fontSize: 20, color: Colors.white))
                  : const Text("Finish",
                      style: TextStyle(fontSize: 20, color: Colors.white)))),
    );
  }
}
