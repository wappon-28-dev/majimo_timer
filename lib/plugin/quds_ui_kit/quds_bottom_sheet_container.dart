import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../main.dart';

/// Show modal bottom sheet with buatiful container.
Future<T?> showQudsModalBottomSheet<T>(
        BuildContext context, Widget Function(BuildContext context) builder,
        {EdgeInsets? contentPadding, String? titleText, Widget? title}) async =>
    await showModalBottomSheet<T>(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (c) => _BottomSheetContainer(
              child: builder(c),
              contentPadding: contentPadding,
              title: title,
              titleText: titleText,
            ));

class _BottomSheetContainer extends HookConsumerWidget {
  final Widget child;
  final EdgeInsets? contentPadding;
  final String? titleText;
  final Widget? title;
  _BottomSheetContainer(
      {required this.child, this.title, this.titleText, this.contentPadding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var radius = const BorderRadius.only(
        topRight: Radius.circular(20), topLeft: Radius.circular(20));
    Widget result = ClipRRect(
      borderRadius: radius,
      child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: radius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              if (title != null || titleText != null)
                Divider(
                  height: 1,
                ),
              SizedBox(
                  child: Container(
                child: Material(child: child),
                padding: contentPadding ?? EdgeInsets.symmetric(horizontal: 20),
              )),
            ],
          )),
    );

    result = Theme(
        child: result,
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent));

    result = Scrollbar(child: SingleChildScrollView(child: result));
    return result;
  }

  Widget _buildHeader() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: 35,
            height: 4,
            decoration: BoxDecoration(
                // boxShadow: [BoxShadow(offset: Offset(0.2, 0.2))],
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[400]),
          ),
          if (title != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: title,
            ),
          if (title == null && titleText != null)
            Container(
              child: Text(
                titleText!,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
        ],
      ),
    );
  }
}
