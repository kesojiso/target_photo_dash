import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

// TargetWordsList
class TargetWordsListState {
  const TargetWordsListState({this.pickedList = const []});
  final List<String> pickedList;
  TargetWordsListState copyWith(List<String> pickedList) =>
      TargetWordsListState(pickedList: pickedList);
}

// ImagePick
class ImagePickState {
  const ImagePickState({this.filePath = ""});
  final String filePath;
  ImagePickState copyWith(String filePath) =>
      ImagePickState(filePath: filePath);
}

// Infer
class InferenceState {
  const InferenceState({this.labels = const []});
  final List<ImageLabel> labels;
  InferenceState copyWith(List<ImageLabel> labels) =>
      InferenceState(labels: labels);
}

// Judge Label
class MissionResultState {
  const MissionResultState({this.clearFlg = false});
  final bool clearFlg;
  MissionResultState copyWith(bool clearFlg) =>
      MissionResultState(clearFlg: clearFlg);
}

//MissionPage
class MissionTermState {
  const MissionTermState({this.missionTerm = 0});
  final int missionTerm;
  MissionTermState copyWith(int missionTerm) =>
      MissionTermState(missionTerm: missionTerm);
}

// Score
class ScoreState {
  const ScoreState(
      {this.scoreList = const [false, false, false], this.score = 0});
  final List<bool> scoreList;
  final int score;
  ScoreState copyWith({required List<bool> scoreList, required int score}) =>
      ScoreState(scoreList: scoreList, score: score);
}

class StoreImgPathState {
  const StoreImgPathState({this.storeImgPathList = const ["", "", ""]});
  final List<String> storeImgPathList;
  StoreImgPathState copyWith(List<String> storeImgPathList) =>
      StoreImgPathState(storeImgPathList: storeImgPathList);
}

class TempTimerState {
  const TempTimerState({this.restTime = 30});
  final int restTime;
  TempTimerState copyWith(int restTime) => TempTimerState(restTime: restTime);
}

class ClearTimeLogState {
  const ClearTimeLogState({this.clearTimeList = const [-1, -1, -1]});
  final List<int> clearTimeList;
  ClearTimeLogState copyWith(List<int> clearTimeList) =>
      ClearTimeLogState(clearTimeList: clearTimeList);
}
