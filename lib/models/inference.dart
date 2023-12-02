import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/main.dart';
import 'package:target_photo_dash/states/states.dart';

class InferenceNotifier extends StateNotifier<InferenceState> {
  InferenceNotifier(this.ref) : super(const InferenceState());
  final Ref ref;

  Future inference() async {
    final path = ref.read(imagePickProvider).filePath;
    if (path.isNotEmpty) {
      final InputImage imageFile = InputImage.fromFilePath(path);
      final ImageLabelerOptions options =
          ImageLabelerOptions(confidenceThreshold: 0.5);
      final imageLabeler = ImageLabeler(options: options);
      final labels = await imageLabeler.processImage(imageFile);
      imageLabeler.close();
      state = state.copyWith(labels);
    }
  }
}
