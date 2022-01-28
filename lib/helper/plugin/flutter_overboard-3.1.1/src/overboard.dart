// ignore_for_file: always_declare_return_types, inference_failure_on_function_return_type, inference_failure_on_instance_creation

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:majimo_timer/helper/plugin/flutter_overboard-3.1.1/src/circular_clipper.dart';
import 'package:majimo_timer/helper/plugin/flutter_overboard-3.1.1/src/overboard_animator.dart';
import 'package:majimo_timer/helper/plugin/flutter_overboard-3.1.1/src/page_model.dart';

enum SwipeDirection { LEFT_TO_RIGHT, RIGHT_TO_LEFT, SKIP_TO_LAST }

class OverBoard extends StatefulWidget {
  /// List of pages to render on-boarding
  final List<PageModel> pages;

  /// Offset to set center point of revealing circle
  final Offset? center;

  /// Enable/disable bullets visibility
  final bool showBullets;

  /// Callback method to capture finish button click
  final VoidCallback finishCallback;

  /// Callback method to capture skip button click
  final VoidCallback? skipCallback;

  /// Customize skip button text
  final String? skipText;

  /// Customize next button text
  final String? nextText;

  /// Customize finish button text
  final String? finishText;

  /// Change action button colors
  final Color buttonColor;
  final bool allowScroll;

  /// Change active bullet color
  final Color activeBulletColor;

  /// Change inactive bullet color
  final Color inactiveBulletColor;

  // Overboard background provider
  final ImageProvider<Object>? backgroundProvider;

  OverBoard(
      {Key? key,
      required this.pages,
      this.center,
      this.showBullets = true,
      this.skipText,
      this.nextText,
      this.finishText,
      required this.finishCallback,
      this.skipCallback,
      this.buttonColor = Colors.white,
      this.activeBulletColor = Colors.white,
      this.inactiveBulletColor = Colors.white30,
      this.backgroundProvider,
      this.allowScroll = false})
      : super(key: key);

  @override
  _OverBoardState createState() => _OverBoardState();
}

class _OverBoardState extends State<OverBoard> with TickerProviderStateMixin {
  late OverBoardAnimator _animator;

  ScrollController _scrollController = ScrollController();
  double _bulletPadding = 5, _bulletSize = 5, _bulletContainerWidth = 0;

  int _counter = 0, _last = 0;
  int _total = 0;
  double initial = 0, distance = 0;
  Random random = Random();
  SwipeDirection _swipeDirection = SwipeDirection.RIGHT_TO_LEFT;

  BoxDecoration _boxDecoration = const BoxDecoration();
  final scrollDuration = const Duration(milliseconds: 1500);
  bool isScrolling = false;

  @override
  void initState() {
    super.initState();

    _animator = OverBoardAnimator(this);
    _total = widget.pages.length;

    if (widget.backgroundProvider != null) {
      _boxDecoration = BoxDecoration(
          image: DecorationImage(image: widget.backgroundProvider!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.allowScroll ? _keyboardWrapper() : _getStack(),
    );
  }

  RawKeyboardListener _keyboardWrapper() {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (RawKeyEvent e) {
        if (e is RawKeyDownEvent) {
          if (e.isKeyPressed(LogicalKeyboardKey.arrowRight) &&
              _counter < _total - 1) {
            _goForward();
          } else if (e.isKeyPressed(LogicalKeyboardKey.arrowLeft) &&
              _counter > 0) {
            _goBack();
          }
        }
      },
      child: _scrollWrapper(),
    );
  }

  Listener _scrollWrapper() {
    return Listener(
      onPointerSignal: (event) async {
        if (event is PointerScrollEvent) {
          final scrollDelta = event.scrollDelta.dy;
          if (!isScrolling) {
            isScrolling = true;
            if (scrollDelta.isNegative && _counter > 0) {
              _goBack();
            } else if (!scrollDelta.isNegative && _counter < _total - 1) {
              _goForward();
            }

            await Future<void>.delayed(scrollDuration);
            isScrolling = false;
          }
        }
      },
      child: _getStack(),
    );
  }

  GestureDetector _getStack() {
    return GestureDetector(
      onPanStart: (DragStartDetails details) {
        initial = details.globalPosition.dx;
      },
      onPanUpdate: (DragUpdateDetails details) {
        distance = details.globalPosition.dx - initial;
      },
      onPanEnd: (DragEndDetails details) {
        initial = 0.0;
        setState(() {
          _last = _counter;
        });
        if (distance > 1 && _counter > 0) {
          _goBack();
        } else if (distance < 0 && _counter < _total - 1) {
          _goForward();
        }
      },
      child: Stack(
        children: <Widget>[
          _getPage(_last),
          AnimatedBuilder(
            animation: _animator.getAnimator(),
            builder: (context, child) {
              return ClipOval(
                  clipper: CircularClipper(
                      _animator.getAnimator().value as double, widget.center),
                  child: _getPage(_counter));
            },
            child: Container(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Opacity(
                  child: _getTextButton(
                      widget.skipText ?? "SKIP",
                      widget.skipCallback != null
                          ? widget.skipCallback
                          : _skip),
                  opacity: (_counter < _total - 1) ? 1.0 : 0.0,
                ),
                Expanded(
                  child: Center(child: LayoutBuilder(
                    builder: (context, constraints) {
                      _bulletContainerWidth = constraints.maxWidth - 40.0;
                      return Container(
                        padding: const EdgeInsets.all(20),
                        child: widget.showBullets
                            ? SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                controller: _scrollController,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    for (int i = 0; i < _total; i++)
                                      Padding(
                                        padding: EdgeInsets.all(_bulletPadding),
                                        child: Container(
                                          height: _bulletSize,
                                          width: _bulletSize,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: i == _counter
                                                  ? widget.activeBulletColor
                                                  : widget.inactiveBulletColor),
                                        ),
                                      )
                                  ],
                                ),
                              )
                            : Container(),
                      );
                    },
                  )),
                ),
                (_counter < _total - 1
                    ? _getTextButton(
                        widget.nextText ?? "NEXT",
                        _next,
                      )
                    : _getTextButton(
                        widget.finishText ?? "FINISH", widget.finishCallback)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _getPage(int index) {
    final page = widget.pages[index];
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: _boxDecoration.copyWith(
        color:
            widget.backgroundProvider == null ? page.color : Colors.transparent,
      ),
      child: page.child != null
          ? Center(
              child: page.doAnimateChild
                  ? AnimatedBoard(
                      animator: _animator,
                      child: page.child,
                    )
                  : page.child,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                page.doAnimateImage
                    ? AnimatedBoard(
                        animator: _animator,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Image.asset(page.imageAssetPath!,
                              width: 300, height: 300),
                        ),
                      )
                    : Image.asset(page.imageAssetPath!,
                        width: 300, height: 300),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 30, right: 30),
                  child: Text(
                    page.title!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: page.titleColor ?? Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 75, left: 30, right: 30),
                  child: Text(
                    page.body!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: page.bodyColor ?? Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  TextButton _getTextButton(String _text, void Function()? _onPress) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(20),
      ),
      child: Text(
        _text,
        style: TextStyle(color: widget.buttonColor),
      ),
      onPressed: _onPress,
    );
  }

  void _goForward() {
    setState(() {
      _counter++;
      _swipeDirection = SwipeDirection.RIGHT_TO_LEFT;
    });
    _animate();
  }

  void _goBack() {
    setState(() {
      _counter--;
      _swipeDirection = SwipeDirection.LEFT_TO_RIGHT;
    });
    _animate();
  }

  void _next() {
    setState(() {
      _swipeDirection = SwipeDirection.RIGHT_TO_LEFT;
      _last = _counter;
      _counter++;
    });
    _animate();
  }

  void _skip() {
    setState(() {
      _swipeDirection = SwipeDirection.SKIP_TO_LAST;
      _last = _counter;
      _counter = _total - 1;
    });
    _animate();
  }

  void _animate() {
    _animator.getController().forward(from: 0);

    final _bulletDimension = (_bulletPadding * 2) + _bulletSize;
    final _scroll = _bulletDimension * _counter;
    final _maxScroll = _bulletDimension * _total - 1;
    if (_scroll > _bulletContainerWidth &&
        _swipeDirection == SwipeDirection.RIGHT_TO_LEFT) {
      final _scrollDistance =
          (((_scroll - _bulletContainerWidth) ~/ _bulletDimension) + 1) *
              _bulletDimension;
      _scrollController.animateTo(_scrollDistance,
          curve: Curves.easeIn, duration: const Duration(milliseconds: 100));
    } else if (_scroll < (_maxScroll - _bulletContainerWidth) &&
        _swipeDirection == SwipeDirection.LEFT_TO_RIGHT) {
      _scrollController.animateTo(_scroll,
          curve: Curves.easeIn, duration: const Duration(milliseconds: 100));
    } else if (_swipeDirection == SwipeDirection.SKIP_TO_LAST) {
      _scrollController.animateTo(_maxScroll,
          curve: Curves.easeIn, duration: const Duration(milliseconds: 100));
    }
  }
}

class AnimatedBoard extends StatelessWidget {
  final Widget? child;
  final OverBoardAnimator animator;

  const AnimatedBoard({Key? key, required this.animator, required this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(
          0, 50.0 * (1.0 - (animator.getAnimator().value as num)), 0),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: child,
      ),
    );
  }
}
