import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majimo_timer/main.dart';
import 'package:majimo_timer/plugin/let_log/let_log.dart';
import 'package:workmanager/workmanager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart' as a;

class NotificationManager {
  static void initialize() {
    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        null,
        [
          NotificationChannel(
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: const Color(0xFF9D50DD),
              ledColor: Colors.white)
        ]);
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static void test() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: 'フォアグラウンド処理テスト',
            body: 'from まじもタイマー'));
  }

  static void background() {
    Logger.i("called background");
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: 'バックグラウンド処理テスト',
            body: 'from まじもタイマー'));
  }
}

class ToastManager {
  static void toast(
      {required BuildContext context,
      required int id,
      required WidgetRef ref}) {
    List _array = [];
    bool _topToast = ref.read(generalManager).topToast;
    switch (id) {
      case 0:
        _array = [Colors.green[600]!, Icons.check, "テスト通知"];
        break;
      case 1:
        _array = [Colors.blue, Icons.light, "画面の消灯を一時的にOFFにしました"];
        break;
    }

    a.showToastWidget(
      GestureDetector(
        child: Container(
          // 内側の余白（パディング）
          padding: const EdgeInsets.all(5),
          // 外側の余白（マージン）
          margin: const EdgeInsets.all(10),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: _array[0],
          ),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    _array[1],
                    color: Colors.white,
                  ),
                ),
                Text(
                  _array[2],
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 15)
              ]),
        ),
        onVerticalDragEnd: (_) => a.ToastManager().dismissAll(showAnim: true),
      ),
      context: context,
      isIgnoring: false,
      animation: _topToast
          ? a.StyledToastAnimation.slideFromTopFade
          : a.StyledToastAnimation.slideFromBottomFade,
      reverseAnimation: _topToast
          ? a.StyledToastAnimation.slideToTopFade
          : a.StyledToastAnimation.slideToBottomFade,
      position: _topToast
          ? const a.StyledToastPosition(align: Alignment.topCenter)
          : const a.StyledToastPosition(align: Alignment.bottomCenter),
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 4),
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeOutCirc,
    );
  }
}
