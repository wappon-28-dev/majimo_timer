import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:majimo_timer/model/helper/plugin/let_log/let_log.dart';

class Debug extends HookWidget {
  const Debug({super.key});

  @override
  Widget build(BuildContext context) {
    return Logger();
  }
}
