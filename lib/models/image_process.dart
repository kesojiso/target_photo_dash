import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:target_photo_dash/models/get_target_words_list.dart';
import 'package:target_photo_dash/view_models/mission_page/mission_term_vm.dart';

class ImageProcessState {
  String imagePath;
  List<ImageLabel> imageLabels;
  bool isMissionClear;
  ImageProcessState({
    this.imagePath = "",
    this.imageLabels = const [],
    this.isMissionClear = false,
  });
  ImageProcessState copyWith(
          {String? imagePath,
          List<ImageLabel>? imageLabels,
          bool? isMissionClear}) =>
      ImageProcessState(
          imagePath: imagePath ?? this.imagePath,
          imageLabels: imageLabels ?? this.imageLabels,
          isMissionClear: isMissionClear ?? this.isMissionClear);
}

class ImageProcessStateNotifier extends StateNotifier<ImageProcessState> {
  final Ref ref;
  ImageProcessStateNotifier(this.ref) : super(ImageProcessState());

  Future<void> imagePick() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      state = state.copyWith(imagePath: pickedFile.path);
    }
  }

  Future<void> inference() async {
    if (state.imagePath.isNotEmpty) {
      InputImage imageFile = InputImage.fromFilePath(state.imagePath);
      ImageLabelerOptions options =
          ImageLabelerOptions(confidenceThreshold: 0.5);
      ImageLabeler imageLabeler = ImageLabeler(options: options);
      state = state.copyWith(
          imageLabels: await imageLabeler.processImage(imageFile));
      imageLabeler.close();
    }
  }

  void judgeInclusion() {
    int missionTerm = ref.read(missionTermProvider).missionTerm;
    String targetWord =
        ref.read(targetWordListProvider).pickedList[missionTerm];
    String labelReplaced;
    String targetWordReplaced;
    if (state.imageLabels.isEmpty) {
      state.isMissionClear = false;
      return;
    }
    for (var label in state.imageLabels) {
      labelReplaced = label.label.replaceAll(RegExp(r'\s'), '');
      targetWordReplaced = targetWord.replaceAll(RegExp(r'\s'), '');
      if (labelReplaced == targetWordReplaced) {
        state = state.copyWith(isMissionClear: true);
        return;
      }
    }
    state = state.copyWith(isMissionClear: false);
    return;
  }
}

final imageProcessStateProvider =
    StateNotifierProvider<ImageProcessStateNotifier, ImageProcessState>(
        (ref) => ImageProcessStateNotifier(ref));
