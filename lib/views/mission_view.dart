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
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Target : ", style: AppTheme.title),
                  TargetWordTextWidget()
                ])),
        body: const Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            StackContainer(),
            Spacer(),
            CameraButtonWidget(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              BackButtonWidget(),
              NextButtonWidget(),
            ])
          ]),
        ));
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

class CameraButtonWidget extends ConsumerWidget {
  const CameraButtonWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
        onTap: () async {
          await ref.read(imagePickProvider.notifier).imagePick();
          await ref.read(inferenceProvider.notifier).inference();
          ref.read(missionResultProvider.notifier).judgeInclusion();
          ref.read(scoreStateProvider.notifier).updateScore();
        },
        child: Stack(alignment: Alignment.center, children: [
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
        ]));
  }
}

class BackButtonWidget extends ConsumerWidget {
  const BackButtonWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionTermState = ref.watch(missionPageProvider);
    final missionTermNotifier = ref.watch(missionPageProvider.notifier);
    return Padding(
        padding: const EdgeInsets.all(20),
        child: missionTermState.missionTerm > 0
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 10,
                    fixedSize: const Size(150, 70),
                    backgroundColor: AppTheme.nearlyBlack),
                onPressed: () {
                  missionTermNotifier.decrement();
                  ref.invalidate(inferenceProvider);
                  ref.invalidate(imagePickProvider);
                },
                child: const Center(
                    child: Text("Back",
                        style: TextStyle(fontSize: 20, color: Colors.white))))
            : Container());
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
              fixedSize: const Size(150, 70),
              backgroundColor: AppTheme.nearlyBlack),
          onPressed: () {
            missionTermNotifier.increment();
            ref.invalidate(inferenceProvider);
            ref.invalidate(imagePickProvider);
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 2 / 3,
          child: Stack(alignment: Alignment.center, children: [
            Image.file(
              File(filePath),
              fit: BoxFit.contain,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 2 / 3,
                height: MediaQuery.of(context).size.height * 1 / 2,
                color: Colors.white.withOpacity(0.5),
                child: const Column(
                  children: [
                    TaskResultWidget(),
                    ShowInferLabelWidget(),
                  ],
                )),
          ]));
    } else {
      return const Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: Center(
              child: Text(
            "Take this photo!!",
            style: AppTheme.headline,
          )),
        ),
        Padding(
            padding: EdgeInsets.only(top: 20.0), child: TargetWordTextWidget())
      ]);
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
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)));
              }));
    } else {
      return Container();
    }
  }
}
