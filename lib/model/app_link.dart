// ignore_for_file: implementation_imports, avoid_void_async

import 'package:app_links/app_links.dart';
import 'package:dismissible_page/src/dismissible_extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majimo_timer/main.dart';
import 'package:majimo_timer/model/translations.dart';
import 'package:majimo_timer/plugin/let_log/let_log.dart';
import 'package:majimo_timer/view/home/alarm/body.dart';
import 'package:majimo_timer/view/home/goal/body.dart';
import 'package:majimo_timer/view/home/timer/body.dart';
import 'package:quick_actions/quick_actions.dart';

late AppLinks _appLinks;

class LinkManager {
  static void initDeepLinks(WidgetRef ref, BuildContext context) async {
    //receive
    _appLinks = AppLinks(onAppLink: (Uri uri, String stringUri) async {
      receiver(stringUri, context, ref);
      Logger.i(' >> not late => $uri');
    });

    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null && appLink.hasFragment) {
      receiver(appLink.toString(), context, ref);
      Logger.i(' >> late => $appLink');
    }
  }

  static void receiver(String uri, BuildContext context, WidgetRef ref) {
    if (uri.startsWith('m')) {
      // ignore: parameter_assignments
      uri = uri.replaceAll('majimo://app/', '');
    }
    if (uri.startsWith('h')) {
      // ignore: parameter_assignments
      uri = uri.replaceAll('https://majimo.jp/app/', '');
    }
    Logger.i('transferred -> $uri');
    launcher(context, ref, uri);
  }

  static void launcher(BuildContext context, WidgetRef ref, String mode) {
    switch (mode) {
      case 'h':
        Navigator.of(context).pushReplacementNamed('/home');
        break;

      case 'a':
        Navigator.of(context).pushReplacementNamed('/home');
        context.pushTransparentRoute(const AlarmPage());
        ref.watch(alarmManager).internal();
        ref.watch(alarmManager).show();
        break;

      case 't':
        Navigator.of(context).pushReplacementNamed('/home');
        context.pushTransparentRoute(const TimerPage());
        break;

      case 'g':
        Navigator.of(context).pushReplacementNamed('/home');
        context.pushTransparentRoute(const GoalPage());
        break;

      case 's':
        Navigator.of(context).pushReplacementNamed('/home');
        Navigator.of(context).pushNamed('/setting');

        break;
    }
  }

  static void initQuickAction(
      {required BuildContext context, required WidgetRef ref}) {
    const quickActions = QuickActions();
    // ignore: cascade_invocations
    quickActions.initialize((shortcutType) async {
      launcher(context, ref, shortcutType);
    });
    // ignore: cascade_invocations
    quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(type: 'g', localizedTitle: t.goal.t, icon: 'ic_launcher'),
      ShortcutItem(type: 't', localizedTitle: t.timer.t, icon: 'ic_launcher'),
      ShortcutItem(type: 'a', localizedTitle: t.alarm.t, icon: 'ic_launcher'),
    ]);
  }

  void h() => '';
}
