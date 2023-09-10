import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

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

  /// Image Pickerのカメラを使って画像を取得する
  Future<void> getImageFromCamera() async {
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
        const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Target:", style: TextStyle(fontSize: 20))),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Flower",
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold))),
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
              return const Text("Loading");
            }
          },
        )
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            getImageFromCamera();
          },
          child: const Icon(Icons.camera_alt)),
    );
  }
}
