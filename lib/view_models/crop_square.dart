import 'dart:io';
import 'package:image/image.dart' as img;

Future<File> cropSquare(File originalImage) async {
  img.Image image = img.decodeImage(originalImage.readAsBytesSync())!;

  // 短い方の辺を取得
  int minLength = image.width < image.height ? image.width : image.height;

  // 画像を正方形にクロップ
  img.Image cropped = img.copyCrop(image,
      x: ((image.width - minLength) ~/ 2),
      y: ((image.height - minLength) ~/ 2),
      width: minLength,
      height: minLength);

  // クロップした画像を保存
  File croppedFile = File(originalImage.path)
    ..writeAsBytesSync(img.encodeJpg(cropped));
  return croppedFile;
}
