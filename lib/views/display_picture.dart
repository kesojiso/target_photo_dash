import 'package:flutter/material.dart';
import 'dart:io';

class DisplayPicture extends StatelessWidget {
  final String imagePath;
  const DisplayPicture({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("Mission")),
        body: Center(child: Image.file(File(imagePath))));
  }
}
