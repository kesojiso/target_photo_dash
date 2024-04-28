import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:target_photo_dash/view_models/mission_page/temp_timer.dart';
import 'package:target_photo_dash/views/mission_view/mission_view.dart';

class CameraButtonSelectorWidget extends ConsumerWidget {
  const CameraButtonSelectorWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(tempTimerProvider).timer;
    return timer == 30
        ? const DummyCameraButtonWidget()
        : const CameraButtonWidget();
  }
}

class CameraButtonWidget extends ConsumerWidget {
  const CameraButtonWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        wholeImageProcess(ref);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration:
                const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
          ),
          const Icon(Icons.camera, size: 55)
        ],
      ),
    );
  }
}

class DummyCameraButtonWidget extends ConsumerWidget {
  const DummyCameraButtonWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Time Up!'),
              content: const Text('Go to next mission!'),
              actions: <Widget>[
                TextButton(
                  child: const Text('close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration:
                const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
          ),
          Container(
            width: 60,
            height: 60,
            decoration:
                const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
          ),
          const Icon(
            Icons.block,
            size: 55,
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
