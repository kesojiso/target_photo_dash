import 'package:flutter/material.dart';
import 'package:target_photo_dash/themes/app_theme.dart';
import 'package:target_photo_dash/views/mission_view.dart';

class PreviousMissionPage extends StatelessWidget {
  const PreviousMissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text("Are You Ready??", style: AppTheme.display1),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MissionView()));
                    },
                    child: const Center(
                        child: Text("OK!",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            )))))),
      ],
    )));
  }
}
