import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/themes/app_theme.dart';
import 'package:target_photo_dash/views/mission_view/mission_view.dart';
import 'package:target_photo_dash/models/get_target_words_list.dart';
import 'package:target_photo_dash/view_models/mission_page/temp_timer.dart';

class PreviousMissionPage extends ConsumerWidget {
  const PreviousMissionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text("Are You Ready??", style: AppTheme.display1),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                  '1. Target word will be given.\n2. take a picture corresponds to the word.\n3. Picture you took will be judged.',
                  style: AppTheme.body1),
            ),
            //const Spacer(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 10,
                      fixedSize: const Size(200, 70),
                      backgroundColor: AppTheme.nearlyBlack),
                  onPressed: () {
                    ref
                        .read(targetWordListProvider.notifier)
                        .getTargetWordsList();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MissionPage()));
                    ref.read(tempTimerProvider.notifier).stopTimer();
                    ref.read(tempTimerProvider.notifier).startTimer(30);
                  },
                  child: const Center(
                    child: Text(
                      "OK!",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
