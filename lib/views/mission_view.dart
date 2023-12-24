import 'package:flutter/material.dart';
import 'dart:io';
import 'package:target_photo_dash/main.dart';
import 'package:target_photo_dash/themes/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/views/result_page.dart';

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
  const TimerWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restTime = ref.watch(tempTimerProvider).restTime;
    return Row(children: [
      const Icon(Icons.timer_outlined),
      Text('00:${restTime.toString().padLeft(2, "0")}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    ]);
  }
}

class TargetWordTextWidget extends ConsumerWidget {
  const TargetWordTextWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetWordsListState = ref.watch(targetWordListProvider);
    final missionTermState = ref.watch(missionPageProvider);
    final targetWordsList = targetWordsListState.pickedList;
    final missionTerm = missionTermState.missionTerm;
    if (targetWordsList.isNotEmpty) {
      return Text(targetWordsList[missionTerm], style: AppTheme.headline);
    } else {
      return const CircularProgressIndicator();
    }
  }
}

class CameraButtonSelectorWidget extends ConsumerWidget {
  const CameraButtonSelectorWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restTime = ref.watch(tempTimerProvider).restTime;
    return Stack(
      children: [
        Offstage(
          offstage: restTime == 0, // 残時間が０ならCameraButtonWidgetを除外
          child: const CameraButtonWidget(),
        ),
        Offstage(
          offstage: restTime != 0, // 残時間が０でないならDummyCameraButtonWidgetを除外
          child: const DummyCameraButtonWidget(),
        ),
      ],
    );
  }
}

class CameraButtonWidget extends ConsumerWidget {
  const CameraButtonWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        await ref.read(imagePickProvider.notifier).imagePick();
        await ref.read(inferenceProvider.notifier).inference();
        ref.read(missionResultProvider.notifier).judgeInclusion();
        ref.read(clearTimeLogStateProvider.notifier).logClearTime();
        ref.read(scoreStateProvider.notifier).updateScore();
        ref.read(storeImageStateProvider.notifier).addImage();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration:
                const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
          ),
          const Icon(Icons.camera, size: 55)
        ],
      ),
    );
  }
}

class DummyCameraButtonWidget extends ConsumerWidget {
  const DummyCameraButtonWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Time Up!'),
              content: const Text('Go to next mission!'),
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
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration:
                const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
          ),
          Container(
            width: 60,
            height: 60,
            decoration:
                const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
          ),
          const Icon(
            Icons.block,
            size: 55,
            color: Colors.black,
          )
        ],
      ),
    );
  }
}

class NextButtonWidget extends ConsumerWidget {
  const NextButtonWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionTermState = ref.watch(missionPageProvider);
    final missionTermNotifier = ref.watch(missionPageProvider.notifier);
    void finishNavigate() {
      if (missionTermState.missionTerm >= 2) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ResultView()));
        ref.invalidate(missionPageProvider);
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
            ref.invalidate(inferenceProvider);
            ref.invalidate(imagePickProvider);
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

class StackContainer extends ConsumerWidget {
  const StackContainer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePickState = ref.watch(imagePickProvider);
    final filePath = imagePickState.filePath;
    if (filePath != "") {
      return Container(
        padding: const EdgeInsets.all(20),
        width: ref.read(screenSizeProvider).width,
        height: ref.read(screenSizeProvider).height * 2 / 3,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.file(
              File(filePath),
              fit: BoxFit.contain,
            ),
            Container(
              width: ref.read(screenSizeProvider).width * 2 / 3,
              height: ref.read(screenSizeProvider).height * 1 / 2,
              color: Colors.white.withOpacity(0.5),
              child: const Column(
                children: [
                  TaskResultWidget(),
                  ShowInferLabelWidget(),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return const Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child: Text(
                "Take this photo!!",
                style: AppTheme.headline,
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: TargetWordTextWidget()),
        ],
      );
    }
  }
}

class TaskResultWidget extends ConsumerWidget {
  const TaskResultWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionResultState = ref.watch(missionResultProvider);
    final clearFlg = missionResultState.clearFlg;
    if (clearFlg) {
      return const Text(
        "OK",
        style: TextStyle(
            fontSize: 40, fontWeight: FontWeight.bold, color: Colors.green),
      );
    } else {
      return const Text(
        "NG",
        style: TextStyle(
            fontSize: 40, fontWeight: FontWeight.bold, color: Colors.red),
      );
    }
  }
}

class ShowInferLabelWidget extends ConsumerWidget {
  const ShowInferLabelWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inferenceState = ref.watch(inferenceProvider);
    final labels = inferenceState.labels;
    if (labels.isNotEmpty) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: ListView.builder(
          itemCount: inferenceState.labels.length,
          itemBuilder: (BuildContext context, index) {
            return Center(
              child: Text(
                '${labels[index].label} - ${labels[index].confidence.toStringAsFixed(2)}',
                style: const TextStyle(
//                            color: Colors.green,
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }
}
