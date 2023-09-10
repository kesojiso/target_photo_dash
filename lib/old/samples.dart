import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:target_photo_dash/models/utils.dart';

final recognitionsProvider = StateProvider<List<ImageLabel>>((ref) => []);

final mlCameraProvider =
    FutureProvider.autoDispose.family<MLCamera, Size>((ref, size) async {
  final cameras = await availableCameras();
  final cameraController = CameraController(
    cameras[0],
    ResolutionPreset.low,
    enableAudio: false,
  );
  await cameraController.initialize();
  final mlCamera = MLCamera(
    ref.read,
    cameraController,
    size,
  );
  return mlCamera;
});

class MLCamera {
  MLCamera(
    this._read,
    this.cameraController,
    this.cameraViewSize,
  ) {
    Future(() async {
      // 画像ストリーミングを開始
      await cameraController.startImageStream(onLatestImageAvailable);
    });
  }
  final Function<T>(ProviderListenable<T>) _read;
  final CameraController cameraController;

  /// スクリーンのサイズ
  Size cameraViewSize;

  /// アスペクト比
  late double ratio;

  /// 現在推論中か否か
  bool isPredicting = false;

  /// カメラプレビューの表示サイズ
  late Size actualPreviewSize;

  late List inferenceList;

  /// 画像ストリーミングに対する処理
  Future<void> onLatestImageAvailable(CameraImage cameraImage) async {
    if (isPredicting) {
      return;
    }
    isPredicting = true;

    // 推論処理は重く、Isolateを使わないと画面が固まる
    inferenceList = await compute(inference, cameraImage);
    _read(recognitionsProvider).state = inferenceList;
    isPredicting = false;
  }

  /// Isolateへ渡す推論関数
  static Future<List<ImageLabel>> inference(CameraImage cameraImage) async {
    final InputImage inputImage = cameraImageToInputImage(cameraImage);
    final ImageLabelerOptions options =
        ImageLabelerOptions(confidenceThreshold: 0.7);
    final imageLabeler = ImageLabeler(options: options);
    print("----------inferenced--------------");
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

    return labels;
  }
}
