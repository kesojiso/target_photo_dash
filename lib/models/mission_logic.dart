import 'package:flutter/services.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:target_photo_dash/models/app_theme.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class MissionLogic {
  final imagePicker = ImagePicker();

  Future<List<String>> getTargetWordsList() async {
    final labels = await rootBundle.loadString("assets/target_labels.txt");
    final labelsList = labels.split("\n");
    final random = Random();
    final List<String> shuffleList = List.of(labelsList)..shuffle(random);
    final List<String> pickedList = shuffleList.take(3).toList();
    return pickedList;
  }

  Future<String?> imagePick() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return pickedFile.path;
    } else {
      return null;
    }
  }

  Future<List<ImageLabel?>> inference(String path) async {
    final InputImage imageFile = InputImage.fromFilePath(path);
    final ImageLabelerOptions options =
        ImageLabelerOptions(confidenceThreshold: 0.5);
    final imageLabeler = ImageLabeler(options: options);
    final labels = await imageLabeler.processImage(imageFile);
    imageLabeler.close();
    return labels;
  }

  bool judgeItemsInclusion({List? labels, required String targetWord}) {
    String labelReplaced;
    String targetWordReplaced;
    if (labels == null) {
      return false;
    }
    for (var label in labels) {
      labelReplaced = label.label.replaceAll(RegExp(r'\s'), '');
      targetWordReplaced = targetWord.replaceAll(RegExp(r'\s'), '');
      if (labelReplaced == targetWordReplaced) {
        return true;
      }
    }
    return false;
  }
}
