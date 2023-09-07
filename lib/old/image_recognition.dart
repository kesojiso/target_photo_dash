// import 'dart:math';

// import 'package:flutter/services.dart';
// import 'package:image/image.dart' as image_lib;
// import 'package:tflite_flutter/tflite_flutter.dart';
// //import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

// import 'package:target_photo_dash/models/utils.dart';

// class Classifier {
//   Classifier({
//     Interpreter? interpreter,
//     List<String>? labels,
//   }) {
//     loadModel(interpreter);
//     loadLabels(labels);
//   }
//   Interpreter? _interpreter;
//   Interpreter? get interpreter => _interpreter;
//   List<String>? _labels;
//   List<String>? get labels => _labels;
//   static const String modelFileName = 'detect.tflite';
//   static const String labelFileName = 'labelmap.txt';

//   static const int inputSize = 300;
//   static const double threshold = 0.6;

//   ImageProcessor? imageProcessor;

//   late List<List<int>> _outputShapes;
//   late List<TfLiteType> _outputTypes;

//   static const int numResults = 10;

//   Future<void> loadModel(Interpreter? interpreter) async {
//     try {
//       _interpreter = interpreter ??
//           await Interpreter.fromAsset(
//             modelFileName,
//             options: InterpreterOptions()..threads = 4,
//           );
//       final outputTensors = _interpreter!.getOutputTensors();
//       _outputShapes = [];
//       _outputTypes = [];
//       for (final tensor in outputTensors) {
//         _outputShapes.add(tensor.shape);
//         _outputTypes.add(tensor.type);
//       }
//     } on Exception catch (e) {
//       print("Error while creating interpreter: $e");
//     }
//   }

//   Future<void> loadLabels(List<String>? labels) async {
//     try {
//       _labels = labels ?? await rootBundle.loadString('assets/$labelFileName');
//       _labels.split;
//     } on Exception catch (e) {
//       print("Error while loading labels: $e");
//     }
//   }

//   TensorImage getProcessedImage(TensorImage inputImage) {
//     final padSize = max(inputImage.height, inputImage.width);

//     imageProcessor ??= ImageProcessorBuilder()
//         .add(ResizeWithCropOrPadOp(padSize, padSize))
//         .add(ResizeOp(
//           inputSize,
//           inputSize,
//           ResizeMethod.BILINEAR,
//         ))
//         .build();
//     return imageProcessor!.process(inputImage);
//   }

//   List<Recognition>? predict(image_lib.Image image) {
//     if (_interpreter == null) {
//       return null;
//     }

//     var inputImage = TensorImage.fromImage(image);
//     inputImage = getProcessedImage(inputImage);

//     final outputLocations = TensorBufferFloat(_outputShapes[0]);
//     final outputClasses = TensorBufferFloat(_outputShapes[1]);
//     final outputScores = TensorBufferFloat(_outputShapes[2]);
//     final numLocations = TensorBufferFloat(_outputShapes[3]);

//     final inputs = [inputImage.buffer];
//     final outputs = {
//       0: outputLocations.buffer,
//       1: outputClasses.buffer,
//       2: outputScores.buffer,
//       3: numLocations.buffer,
//     };
//     _interpreter!.runForMultipleInputs(inputs, outputs);

//     final resultCount = min(numResults, numLocations.getIntValue(0));

//     const labelOffset = 1;

//     final locations = BoundingBoxUtils.convert(
//         tensor: outputLocations,
//         valueIndex: [1, 0, 3, 2],
//         boundingBoxAxis: 2,
//         boundingBoxType: BoundingBoxType.BOUNDARIES,
//         coordinateType: CoordinateType.RATIO,
//         height: inputSize,
//         width: inputSize);

//     final recognitions = <Recognition>[];
//     for (var i = 0; i < resultCount; i++) {
//       final score = outputScores.getDoubleValue(i);
//       final labelIndex = outputClasses.getIntValue(i) + labelOffset;
//       final label = _labels!.elementAt(labelIndex);

//       if (score > threshold) {
//         final transformRect = imageProcessor!
//             .inverseTransformRect(locations[i], image.height, image.width);
//         recognitions.add(Recognition(i, label, score, transformRect));
//       }
//     }
//     return recognitions;
//   }
// }
