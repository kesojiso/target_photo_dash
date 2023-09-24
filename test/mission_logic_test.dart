import 'package:test/test.dart';
import 'package:target_photo_dash/models/mission_logic.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

class MockImageLabel extends Mock implements ImageLabel {
  @override
  String get label => super.noSuchMethod(
        Invocation.getter(#label),
        returnValue: '',
      );

  @override
  double get confidence => super.noSuchMethod(
        Invocation.getter(#confidence),
        returnValue: 0.0,
      );

  @override
  int get index => super.noSuchMethod(
        Invocation.getter(#index),
        returnValue: 0,
      );

  MockImageLabel() {
    when(() => label).thenReturn(() => "");
    when(() => confidence).thenReturn(() => 0.0);
    when(() => index).thenReturn(() => 0);
  }
}

@GenerateMocks([], customMocks: [MockSpec<ImageLabel>(as: #MockImageLabel)])
void main() {
  final missionLogic = MissionLogic();
  group('judgeItemsInclusion', () {
    test('labels is null returns false', () {
      expect(missionLogic.judgeItemsInclusion(labels: null, targetWord: 'test'),
          false);
    });

    test('targetWord found in labels returns true', () {
      var mockLabel1 = MockImageLabel();
      var mockLabel2 = MockImageLabel();
      when(mockLabel1.label).thenReturn('test word');
      when(mockLabel1.confidence).thenReturn(0.5);
      when(mockLabel1.index).thenReturn(0);
      when(mockLabel2.label).thenReturn('another word');
      when(mockLabel2.confidence).thenReturn(0.6);
      when(mockLabel2.index).thenReturn(1);
      var labels = [mockLabel1, mockLabel2];
      expect(
          missionLogic.judgeItemsInclusion(
              labels: labels, targetWord: 'testword'),
          true);
    });
  });
}
// void main() {
//   final missionLogic = MissionLogic();
  
//   group('judgeItemsInclusion', () {
//     test('labels is null returns false', () {
//       expect(missionLogic.judgeItemsInclusion(labels: [], targetWord: 'test'),
//           false);
//     });

//     test('targetWord found in labels returns true', () {
//       List labels = [
//         {'label': 'test word'},
//         {'label': 'another word'}
//       ];
//       expect(
//           missionLogic.judgeItemsInclusion(
//               labels: labels, targetWord: 'testword'),
//           true);
//     });

//     test('targetWord not found in labels returns false', () {
//       List labels = [
//         {'label': 'some word'},
//         {'label': 'another word'}
//       ];
//       expect(
//           missionLogic.judgeItemsInclusion(
//               labels: labels, targetWord: 'testword'),
//           false);
//     });

//     test('targetWord with spaces matches label without spaces', () {
//       List labels = [
//         {'label': 'testword'},
//         {'label': 'another word'}
//       ];
//       expect(
//           missionLogic.judgeItemsInclusion(
//               labels: labels, targetWord: 'test word'),
//           true);
//     });
//   });
//}
