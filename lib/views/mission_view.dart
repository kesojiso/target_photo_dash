import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:target_photo_dash/views/previvous_mission.dart';

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
  final PreviousMissionPage previousMissionPage = PreviousMissionPage();

  /// Image Pickerのカメラを使って画像を取得する
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
      labelStreamController.sink.add(labels);
    }
  }

  Future<String> getMissionWords() async {
    String missionWord = "None";
    previousMissionPage.dataStream.listen((data) {
      missionWord = data.join(",");
    });
    print(missionWord);
    return missionWord;
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
          title: const Text("Mission")),
      body: Column(children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Target:", style: TextStyle(fontSize: 20))),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FutureBuilder(
                      future: getMissionWords(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}'); // エラーが発生した場合
                        } else {
                          return Text('Fetched Data: ${snapshot.data}');
                        }
                      }))
            ],
          ),
        ),
        StreamBuilder(
          stream: imagePathStreamController.stream,
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.hasData) {
              return Image.file(File(snapshot.data!));
            } else {
              return Text(
                "Take Target Picture!!",
                style: Theme.of(context).textTheme.headlineLarge,
              );
            }
          },
        ),
        StreamBuilder(
          stream: labelStreamController.stream,
          builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
            if (snapshot.hasData) {
              return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, index) {
                        return ListTile(
                            title: Text(snapshot.data![index].label),
                            subtitle:
                                Text('${snapshot.data![index].confidence}'));
                      }));
            } else {
              return const Text("No Labels");
            }
          },
        )
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            getImageAndInference();
          },
          child: const Icon(Icons.camera_alt)),
    );
  }
}
