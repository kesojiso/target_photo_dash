import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/states/states.dart';

final imagePicker = ImagePicker();

class ImagePickNotifier extends StateNotifier<ImagePickState> {
  ImagePickNotifier() : super(const ImagePickState());

  Future imagePick() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      state = state.copyWith(pickedFile.path);
    } else {
      state = state.copyWith("");
    }
  }
}
