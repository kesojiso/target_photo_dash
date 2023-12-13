import 'package:flutter/material.dart';
import 'package:target_photo_dash/view_models/mission_page/update_score.dart';
import 'package:target_photo_dash/views/homepage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:target_photo_dash/themes/app_theme.dart';
import 'package:target_photo_dash/states/states.dart';
import 'package:target_photo_dash/models/get_target_words_list.dart';
import 'package:target_photo_dash/models/image_pick.dart';
import 'package:target_photo_dash/models/inference.dart';
import 'package:target_photo_dash/view_models/mission_page/store_picture.dart';
import 'package:target_photo_dash/models/mission_result.dart';
import 'package:target_photo_dash/view_models/mission_page/mission_term_vm.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Target Photo Dash';
    const version = '0.1.0';

    return MaterialApp(
        title: title,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: const Color.fromARGB(255, 245, 236, 177),
          scaffoldBackgroundColor: const Color.fromARGB(255, 243, 232, 198),
          fontFamily: AppTheme.fontName,
          textTheme: AppTheme.textTheme,
        ),
        home: const MyHomePage(title: title, version: version),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          "/home": (BuildContext context) =>
              const MyHomePage(title: title, version: version),
        });
  }
}

final screenSizeProvider = StateProvider<Size>((ref) => Size.zero);

final targetWordListProvider =
    StateNotifierProvider<TargetWordsListNotifier, TargetWordsListState>(
        (ref) => TargetWordsListNotifier());

final imagePickProvider =
    StateNotifierProvider<ImagePickNotifier, ImagePickState>(
        (ref) => ImagePickNotifier());

final inferenceProvider =
    StateNotifierProvider<InferenceNotifier, InferenceState>(
        (ref) => InferenceNotifier(ref));

final missionResultProvider =
    StateNotifierProvider<MissionResultNotifier, MissionResultState>(
        (ref) => MissionResultNotifier(ref));

final missionPageProvider =
    StateNotifierProvider<MissionPageStateNotifier, MissionTermState>(
        (ref) => MissionPageStateNotifier());

final scoreStateProvider =
    StateNotifierProvider<ScoreStateNotifier, ScoreState>(
        (ref) => ScoreStateNotifier(ref));

final storeImageStateProvider =
    StateNotifierProvider<StoreImgPathStateNotifier, StoreImgPathState>(
        (ref) => StoreImgPathStateNotifier(ref));
