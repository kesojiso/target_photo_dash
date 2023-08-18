import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:target_photo_dash/views/display_picture.dart';

late List<CameraDescription> cameras;

class CameraLoading extends StatelessWidget {
  Future<CameraController> initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    final controller = CameraController(firstCamera, ResolutionPreset.medium);
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double cameraviewSize = size.width;

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
                  padding: EdgeInsets.all(10),
                  child: Text("Flower",
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        Container(
            width: cameraviewSize,
            height: cameraviewSize,
            child: ClipRect(
                child: OverflowBox(
                    alignment: Alignment.center,
                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: Container(
                            width: cameraviewSize,
                            height: cameraviewSize *
                                widget.controller.value.aspectRatio,
                            child: CameraPreview(widget.controller)))))),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final image = await widget.controller.takePicture();
            final imagePath = image.path;
            final currentContext = context;
            if (!mounted) return;
            Navigator.push(
                currentContext,
                MaterialPageRoute(
                    builder: (context) =>
                        DisplayPicture(imagePath: imagePath)));
          },
          child: const Icon(Icons.camera_alt)),
    );
  }
}
