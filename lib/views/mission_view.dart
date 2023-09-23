import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:target_photo_dash/models/app_theme.dart';
import 'package:target_photo_dash/models/mission_logic.dart';
import 'package:target_photo_dash/views/result_page.dart';

class Args {
  List<bool> scoreList = [false, false, false];
  int missionTerm = 0;
  bool missionClearFlg = false;
  List? targetWords;
  List<ImageLabel?> labels = [];
}

class MissionView extends StatefulWidget {
  const MissionView({super.key});
  @override
  State<MissionView> createState() => _MissionViewState();
}

class _MissionViewState extends State<MissionView> {
  final StreamController<String> imagePathStreamController =
      StreamController.broadcast();
  final StreamController<List<ImageLabel?>> labelStreamController =
      StreamController.broadcast();
  final StreamController<bool> missionJudgeController =
      StreamController.broadcast();
  final MissionLogic missionLogic = MissionLogic();
  final Args args = Args();

  /// 画像を取得し推論を行う
  Future<void> getImageAndInference() async {
    final imagePath = await missionLogic.imagePick();
    if (imagePath != null) {
      imagePathStreamController.sink.add(imagePath);
      args.labels = await missionLogic.inference(imagePath);
      labelStreamController.sink.add(args.labels);
      args.missionClearFlg = missionLogic.judgeItemsInclusion(
          labels: args.labels, targetWord: args.targetWords![args.missionTerm]);
      missionJudgeController.sink.add(args.missionClearFlg);
      args.scoreList =
          _calcScore(args.missionClearFlg, args.missionTerm, args.scoreList);
      setState(() {});
    }
  }

  Future<void> _loadTargetWords() async {
    args.targetWords = await missionLogic.getTargetWordsList();
    if (args.targetWords != null) {
      setState(() {});
    }
  }

  void _goToNextTask() {
    if (args.missionTerm < 2) {
      args.missionClearFlg = false;
      args.labels = [];
      args.missionTerm += 1;
      setState(() {});
      imagePathStreamController.sink.add("");
      labelStreamController.sink.add([]);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => ResultView(scoreList: args.scoreList)),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _backToPreviousTask() {
    args.missionClearFlg = false;
    args.labels = [];
    args.missionTerm -= 1;
    setState(() {});
    imagePathStreamController.sink.add("");
    labelStreamController.sink.add([]);
  }

  List<bool> _calcScore(
      bool missionClearFlg, int missionTerm, List<bool> scoreList) {
    if (scoreList[missionTerm] == false) {
      scoreList[missionTerm] = missionClearFlg;
    }
    return scoreList;
  }

  @override
  void initState() {
    super.initState();
    _loadTargetWords();
  }

  @override
  void dispose() {
    imagePathStreamController.close();
    labelStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              const Text("Target : "),
              args.targetWords == null
                  ? const CircularProgressIndicator()
                  : Text(args.targetWords![args.missionTerm],
                      style: Theme.of(context).textTheme.headlineLarge),
            ])),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            StreamBuilder(
              stream: imagePathStreamController.stream,
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                if (snapshot.hasData && snapshot.data != "") {
                  return Container(
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 2 / 3,
                      child: Stack(alignment: Alignment.center, children: [
                        Image.file(
                          File(snapshot.data!),
                          fit: BoxFit.contain,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 2 / 3,
                            height: MediaQuery.of(context).size.height * 1 / 2,
                            color: Colors.white.withOpacity(0.5),
                            child: Column(
                              children: [
                                StreamBuilder(
                                  stream: missionJudgeController.stream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> snapshot) {
                                    if (snapshot.hasData) {
                                      return Container(
                                        child: args.missionClearFlg == true
                                            ? const Text(
                                                "OK",
                                                style: TextStyle(
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green),
                                              )
                                            : const Text(
                                                "NG",
                                                style: TextStyle(
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                              ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                                StreamBuilder(
                                  stream: labelStreamController.stream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List?> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != []) {
                                      return ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              maxHeight: 200),
                                          child: ListView.builder(
                                              itemCount: snapshot.data!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                return Center(
                                                    child: Text(
                                                        '${snapshot.data![index].label} - ${snapshot.data![index].confidence.toStringAsFixed(2)}',
                                                        style: const TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)));
                                              }));
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ],
                            )),
                      ]));
                } else {
                  return Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Center(
                          child: Text(
                        "Take the picture below !!",
                        style: Theme.of(context).textTheme.headlineSmall,
                      )),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: args.targetWords == null
                            ? const CircularProgressIndicator()
                            : Text(args.targetWords![args.missionTerm],
                                style:
                                    Theme.of(context).textTheme.headlineLarge)),
                  ]);
                }
              },
            ),
            const Spacer(),
            InkWell(
                onTap: () async {
                  getImageAndInference();
                },
                child: Stack(alignment: Alignment.center, children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                        color: Colors.grey, shape: BoxShape.circle),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                  ),
                  const Icon(Icons.camera, size: 55)
                ])),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: args.missionTerm > 0
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(150, 70),
                              backgroundColor: Colors.black),
                          onPressed: () {
                            _backToPreviousTask();
                          },
                          child: const Center(
                              child: Text("Back",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white))))
                      : Container()),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 70),
                        backgroundColor: Colors.black),
                    onPressed: () {
                      _goToNextTask();
                    },
                    child: Center(
                        child: args.missionTerm < 2
                            ? const Text("Submit",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white))
                            : const Text("Finish",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)))),
              )
            ])
          ]),
        ));
  }
}
