import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:majimo_timer/main.dart';
import 'package:majimo_timer/model/theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: ColorKey.orange.value,
          child: Lottie.asset(
            'assets/splash/splash.json',
            controller: _controller,
            height: MediaQuery.of(context).size.height * 1,
            animate: true,
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..forward().whenComplete(
                    () => Navigator.of(context).pushReplacementNamed("/home"));
              Future<void>.delayed(const Duration(seconds: 1));
              ref.read(generalManager).home();
            },
          ),
        ));
  }
}
