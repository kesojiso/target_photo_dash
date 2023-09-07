import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:target_photo_dash/models/utils.dart';
import 'dart:io';
import 'package:target_photo_dash/views/display_picture.dart';
import 'package:target_photo_dash/view_models/crop_square.dart';

late List<CameraDescription> cameras;

class CameraLoading extends StatelessWidget {
  const CameraLoading({super.key});

  Future<CameraController> initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    final controller = CameraController(firstCamera, ResolutionPreset.low);
    await controller.initialize();
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CameraController>(
        future: initCamera(),
        builder:
            (BuildContext context, AsyncSnapshot<CameraController> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('ERROR: ${snapshot.error}');
          } else {
            return MissionView(controller: snapshot.data!);
          }
        });
  }
}

class MissionView extends StatefulWidget {
  final CameraController controller;
  const MissionView({required this.controller, super.key});

  @override
  State<MissionView> createState() => _MissionViewState();
}

class _MissionViewState extends State<MissionView> {
  final _labelStream = StreamController();
  @override
  void initState() {
    super.initState();
    setState(() {});
    widget.controller.startImageStream((image) async {
      final InputImage inputImage = cameraImageToInputImage(image);
      final ImageLabelerOptions options =
          ImageLabelerOptions(confidenceThreshold: 0.7);
      final imageLabeler = ImageLabeler(options: options);
      final List<ImageLabel> labels =
          await imageLabeler.processImage(inputImage);
      _labelStream.sink.add(labels);
      for (ImageLabel label in labels) {
        final String text = label.label;
        final int index = label.index;
        final double confidence = label.confidence;
        print("-----------------------$text------------------------------");
        print("-----------------------$index----------------------------");
        print("-----------------------$confidence----------------------");
      }
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
    _labelStream.close();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.value.isInitialized) {
      return Container();
    }

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
        CameraPreview(widget.controller),
        StreamBuilder(
          stream: _labelStream.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("snapshot.error");
            }
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Text("No Stream");
              case ConnectionState.waiting:
                return const Text("Stream Awaiting");
              case ConnectionState.done:
                return const Text("Stream Closed");
              case ConnectionState.active:
                return Expanded(
                    child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return ListTile(
                              title: Text("$index"),
                              subtitle: Text(
                                  "index:${snapshot.data![index].index}, label:${snapshot.data![index].label},confidence:${snapshot.data![index].confidence}"));
                        }));
            }
          },
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final image = await widget.controller.takePicture();
            final imagePath = File(image.path);
            File croppedFile = await cropSquare(imagePath);
            if (!mounted) return;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DisplayPicture(imagePath: croppedFile.path)));
          },
          child: const Icon(Icons.camera_alt)),
    );
  }
}
