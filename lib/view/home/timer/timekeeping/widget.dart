import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_animations/stateless_animation/play_animation.dart';

import '../../../../main.dart';

Widget buildVertical(BuildContext context, WidgetRef ref) {
  final width = MediaQuery.of(context).size.width;
  final controller = ref.read(timerTKState.notifier).controller;

  Widget content() {
    return Stack(children: [
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
                height: width * 0.9,
                alignment: Alignment.center,
                child: Stack(
                  fit: StackFit.expand,
                  children: [count(context: context, ref: ref)],
                )),
            const SizedBox(height: 10),
            Text(ref.read(alarmTKState).duration.toString()),
            ElevatedButton(
                onPressed: controller.restart, child: const Text('再スタート'))
          ],
        ),
      ),
    ]);
  }

  return Scaffold(
    body: SafeArea(child: content()),
    appBar: appbar(context: context, ref: ref),
  );
}

AppBar appbar({required BuildContext context, required WidgetRef ref}) {
  return AppBar(
    centerTitle: true,
    leading: PlayAnimation(
      tween: Tween<double>(begin: 0, end: 1),
      delay: const Duration(milliseconds: 5900),
      duration: const Duration(milliseconds: 300),
      builder: (context, child, value) {
        return Opacity(
          opacity: value as double,
          child: IconButton(
            icon: const Icon(Icons.alarm),
            onPressed: () {},
            enableFeedback: false,
          ),
        );
      },
    ),
    title: AnimatedOpacity(
        opacity: ref.watch(generalState).opacity,
        duration: const Duration(milliseconds: 300),
        child: AutoSizeText(
          ref.watch(generalState).status,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
        )),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
    ),
    backgroundColor: Colors.red,
  );
}

Widget count({required BuildContext context, required WidgetRef ref}) {
  return Padding(
      padding: const EdgeInsets.all(20),
      child: CircularCountDownTimer(
        duration: ref.read(timerState).target.inSeconds,
        initialDuration: 0,
        controller: ref.read(timerTKState.notifier).controller,
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height / 2,
        ringColor: Colors.red.shade100,
        ringGradient: null,
        fillColor: Colors.redAccent.shade200,
        fillGradient: null,
        backgroundColor: Colors.transparent,
        backgroundGradient: null,
        strokeWidth: 10,
        strokeCap: StrokeCap.butt,
        textStyle: const TextStyle(fontSize: 33.0, fontWeight: FontWeight.bold),
        textFormat: CountdownTextFormat.MM_SS,
        isReverse: true,
        isReverseAnimation: false,
        isTimerTextShown: true,
        autoStart: true,
        onStart: () {
          print('Countdown Started');
        },
        onComplete: () {
          print('Countdown Ended');
        },
      ));
}