import 'dart:async';

import 'package:flutter/cupertino.dart';

class AnimatedFlutterLogo extends StatefulWidget {
  const AnimatedFlutterLogo({super.key});

  @override
  State<AnimatedFlutterLogo> createState() => _AnimatedFlutterLogoState();
}

class _AnimatedFlutterLogoState extends State<AnimatedFlutterLogo> {
  late final ValueNotifier<FlutterLogoStyle> style;
  late final Timer timer;

  @override
  void initState() {
    super.initState();
    style = ValueNotifier(FlutterLogoStyle.markOnly);
    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      final style = this.style.value;
      switch (style) {
        case FlutterLogoStyle.markOnly:
          this.style.value = FlutterLogoStyle.horizontal;
        case FlutterLogoStyle.horizontal:
          this.style.value = FlutterLogoStyle.stacked;
        case FlutterLogoStyle.stacked:
          this.style.value = FlutterLogoStyle.markOnly;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return ValueListenableBuilder(
      valueListenable: style,
      builder: (context, style, child) {
        return FlutterLogo(
          style: style,
          textColor: theme.textTheme.textStyle.color!,
        );
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    style.dispose();
    super.dispose();
  }
}
