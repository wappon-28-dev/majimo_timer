import 'package:auto_size_text/auto_size_text.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majimo_timer/main.dart';
import 'package:majimo_timer/model/helper/plugin/let_log/let_log.dart';
import 'package:majimo_timer/model/helper/plugin/slide_digital_clock/slide_digital_clock.dart';
import 'package:majimo_timer/model/helper/theme.dart';
import 'package:majimo_timer/model/helper/translations.dart';
import 'package:majimo_timer/view/components/modal.dart';
import 'package:majimo_timer/view/components/rounded_card.dart';

import '../../../main.dart';

part 'horizontal.dart';
part 'vertical.dart';

class AlarmPage extends HookConsumerWidget {
  const AlarmPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final alarmstate = ref.read(alarmState.notifier);
    final show = ref.watch(generalState).showFAB;
    const tag = 'alarm';

    Widget _fab() => SizedBox(
          height: 80,
          width: 80,
          child: GestureDetector(
            onLongPress: () => alarmstate.runTooltip(context: context),
            onLongPressUp: () => Navigator.pop(context),
            child: FloatingActionButton(
              onPressed: () {
                alarmstate.runPush(context: context, ref: ref);
              },
              splashColor: Colors.green.shade300,
              backgroundColor: Colors.green.shade200,
              heroTag: null,
              child: const Icon(
                Icons.play_arrow,
                color: Colors.black,
              ),
            ),
          ),
        );

    AppBar _appbar() {
      return AppBar(
        backgroundColor: ColorKey.blue.value,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        elevation: 0,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.hourglass_top),
              AutoSizeText(
                t.alarm.t,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              smallclock(context, ref, false),
            ],
          )
        ],
      );
    }

    return Hero(
      tag: tag,
      child: DismissiblePage(
        onDismiss: () {
          Navigator.of(context).pop();
        },
        isFullScreen: true,
        child: Scaffold(
          appBar: _appbar(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: show ? _fab() : null,
          backgroundColor: const Color.fromRGBO(0, 163, 255, 1),
          body: !isLandscape
              ? buildVertical(context, ref)
              : buildHorizontal(context),
        ),
      ),
    );
  }
}
