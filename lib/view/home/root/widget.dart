// ignore_for_file: implementation_imports

import 'package:dismissible_page/src/dismissible_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fader/flutter_fader.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:majimo_timer/main.dart';
import 'package:majimo_timer/model/app_link.dart';
import 'package:majimo_timer/model/manager.dart';
import 'package:majimo_timer/model/notification.dart';
import 'package:majimo_timer/model/translations.dart';
import 'package:majimo_timer/plugin/let_log/let_log.dart';
import 'package:majimo_timer/plugin/slide_digital_clock/slide_digital_clock.dart';
import 'package:majimo_timer/view/home/alarm/body.dart';
import 'package:majimo_timer/view/home/goal/body.dart';
import 'package:majimo_timer/view/home/timer/body.dart';
<<<<<<< HEAD
=======
import 'package:majimo_timer/vm/viewmodel.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:url_launcher/url_launcher.dart';
>>>>>>> 11f2098393c2b2228b4fe5801ca023b585fd671b
import '/model/theme.dart';
import '../../../plugin/draggable_home/draggable_home.dart';
import 'body.dart';

Widget buildVertical(BuildContext context, WidgetRef ref) {
  final colormanager = ref.read(colorManager);
  final alarmmanager = ref.read(alarmManager);
  final width = MediaQuery.of(context).size.width;
  useEffect(() {
    LinkManager.initQuickAction(context: context, ref: ref);
    LinkManager.initDeepLinks(ref, context);
    // AwesomeNotifications().actionStream.listen((receivedNotification) {
    //   if (receivedNotification.channelKey == "basic_channel") {
    //     Logger.e("received!");
    //     Navigator.of(context).pushNamed(
    //       '/setting',
    //     );
    //   }
    // });
  });

  // ignore: avoid_unnecessary_containers
  Container headerWidget(BuildContext context) => Container(
        child: Container(child: largeclock(context, ref, false)),
      );

  Widget button({required String tag}) {
    var value = Colors.black;
    switch (tag) {
      case 'alarm':
        value = ColorKey.blue.value;
        break;
      case 'timer':
        value = ColorKey.red.value;
        break;
      case 'goal':
        value = ColorKey.green.value;
        break;
    }

    /// ```
    ///  int mode 0 => define onTap()
    ///           1 => return Color
    ///           2 => return Icon
    /// ```
    func({required int mode}) {
      switch (mode) {
        case 0:
          switch (tag) {
            case 'alarm':
              context.pushTransparentRoute(const AlarmPage());
              alarmmanager.internal();
              alarmmanager.show();
              break;
            case 'timer':
              context.pushTransparentRoute(const TimerPage());
              break;
            case 'goal':
              context.pushTransparentRoute(const GoalPage());
              break;
          }
          break;
        case 1:
          switch (tag) {
            case 'alarm':
              return Icons.alarm;
            case 'timer':
              return Icons.hourglass_top;
            case 'goal':
              return Icons.flag;
          }
          break;
        default:
          throw Exception('error!');
      }
    }

    return GestureDetector(
        onTap: () => func(mode: 0),
        child: Hero(
          tag: tag,
          child: Material(
            color: Colors.transparent,
            child: SizedBox.square(
              dimension: width / 3.6,
              child: Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0), color: value),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(func(mode: 1), color: Colors.white),
                      Text(
                        tag.tr(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ]),
              ),
            ),
          ),
        ));
  }

  Widget content(BuildContext context) {
    print(ref.watch(generalManager).opacity);
    return Column(
      children: [
        AnimatedOpacity(
            opacity: ref.watch(generalManager).opacity,
            duration: const Duration(milliseconds: 300),
            child: Text(ref.watch(generalManager).status,
                style: const TextStyle(fontWeight: FontWeight.bold))),
        const SizedBox(height: 20),
        Row(
          // 中央寄せ
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            button(tag: 'alarm'),
            button(tag: 'timer'),
            button(tag: 'goal'),
          ],
        ),
        TextButton(
            onPressed: () async {
              NotificationManager.test();
            },
            child: const Text('NotificationManager.test()')),
      ],
    );
  }

  Widget expand(BuildContext context) {
    final color = colormanager.color;
    final opacity = colormanager.opacity;
<<<<<<< HEAD
    final path = colormanager.color_picture_path(context: context);
=======
    final path = ColorManagerVM(ref.read).color_picture_path(context: context);
>>>>>>> 11f2098393c2b2228b4fe5801ca023b585fd671b
    return AnimatedBuilder(
        animation: color,
        builder: (context, snapshot) {
          return Container(
              alignment: Alignment.center,
              color: color.value as Color,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    AnimatedOpacity(
                        opacity: opacity.value as double,
                        duration: const Duration(seconds: 1),
                        child: Lottie.asset(path)),
                  ]),
                  AnimatedOpacity(
                    opacity: opacity.value as double,
                    duration: const Duration(seconds: 1),
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: analogclock(
                              showSec: ref.read(clockManager).showSec,
                              isLight: ref
                                  .read(themeManager)
                                  .isLight(context: context))),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      largeclock(context, ref, true, true),
                    ],
                  )
                ],
              ));
        });
  }

  return DraggableHome(
    title: Text(
      t.app_name.t,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    actions: [
      IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/debug');
          Logger.e('- from majimo_timer/lib/view/home/root/widget.dart \n' +
              ' > debug page opened');
        },
        icon: const Icon(Icons.developer_mode),
        color: Colors.white,
      ),
      IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/setting');
        },
        icon: const Icon(Icons.settings),
        color: Colors.white,
      ),
    ],
    headerWidget: headerWidget(context),
    headerBottomBar: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/debug');
            Logger.e('- from majimo_timer/lib/view/home/root/widget.dart \n' +
                ' > debug page opened');
          },
          icon: const Icon(Icons.developer_mode),
          color: Colors.white,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/setting');
          },
          icon: const Icon(Icons.settings),
          color: Colors.white,
        ),
      ],
    ),
    body: [
      content(context),
    ],
    fullyStretchable: true,
    expandedBody: expand(context),
  );
}
