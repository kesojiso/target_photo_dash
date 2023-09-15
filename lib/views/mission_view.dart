import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:target_photo_dash/models/pick_mission_words.dart';

class MissionView extends StatefulWidget {
  const MissionView({super.key});
  @override
  State<MissionView> createState() => _MissionViewState();
}

class _MissionViewState extends State<MissionView> {
  final imagePicker = ImagePicker();
  final StreamController<String> imagePathStreamController =
      StreamController<String>();
  final StreamController<List<ImageLabel>> labelStreamController =
      StreamController<List<ImageLabel>>();
  List<String>? missionWords;

  /// 画像を取得し推論を行う
  Future<void> getImageAndInference() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imagePathStreamController.sink.add(pickedFile.path);
      final InputImage imageFile = InputImage.fromFilePath(pickedFile.path);
      final ImageLabelerOptions options =
          ImageLabelerOptions(confidenceThreshold: 0.5);
      final imageLabeler = ImageLabeler(options: options);
      final List<ImageLabel> labels =
          await imageLabeler.processImage(imageFile);
      imageLabeler.close();
      labelStreamController.sink.add(labels);
    }
  }

  Future<void> _loadMissionWords() async {
    missionWords = await getMissionWordsList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadMissionWords();
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
      //backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const Text("Target : "),
            missionWords == null
                ? const CircularProgressIndicator()
                : Text(missionWords![0],
                    style: Theme.of(context).textTheme.headlineLarge),
          ])),
      body: Center(
          child: Column(children: [
        StreamBuilder(
          stream: imagePathStreamController.stream,
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.hasData) {
              return Stack(children: [
                Image.file(File(snapshot.data!)),
                // Container(
                //   color: Colors.white.withOpacity(0.5),
                //   width: double.infinity,
                //   height: double.infinity,
                // ),
                StreamBuilder(
                  stream: labelStreamController.stream,
                  builder:
                      (BuildContext context, AsyncSnapshot<List?> snapshot) {
                    if (snapshot.hasData) {
                      return ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, index) {
                                return ListTile(
                                    title: Text(snapshot.data![index].label),
                                    subtitle: Text(
                                        '${snapshot.data![index].confidence}'));
                              }));
                    } else {
                      return Container();
                    }
                  },
                ),
              ]);
            } else {
              return Column(children: [
                Text(
                  "Take the picture below !!",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: missionWords == null
                        ? const CircularProgressIndicator()
                        : Text(missionWords![0],
                            style: Theme.of(context).textTheme.headlineLarge))
              ]);
            }
          },
        ),
        const Spacer(),
        InkWell(
            onTap: () async {
              getImageAndInference();
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                  color: Colors.grey, shape: BoxShape.circle),
            )),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                  onPressed: () async {
                    getImageAndInference();
                  },
                  child: const Center(
                      child: Text("Retake", style: TextStyle(fontSize: 30))))),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Center(
                    child: Text("Submit", style: TextStyle(fontSize: 30)))),
          )
        ])
      ])),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () async {
      //       getImageAndInference();
      //     },
      //     child: const Icon(Icons.camera_alt)),
    );
  }
}
