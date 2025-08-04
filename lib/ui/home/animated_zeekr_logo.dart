import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:zeekr/ui/widgets.dart';

class AnimatedZeekrLogo extends StatefulWidget {
  const AnimatedZeekrLogo({super.key});

  @override
  State<AnimatedZeekrLogo> createState() => _AnimatedZeekrLogoState();
}

class _AnimatedZeekrLogoState extends State<AnimatedZeekrLogo> {
  late final ValueNotifier<ZeekrLogoStyle> style;
  late final Timer timer;

  @override
  void initState() {
    super.initState();
    style = ValueNotifier(ZeekrLogoStyle.markOnly);
    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      final style = this.style.value;
      switch (style) {
        case ZeekrLogoStyle.markOnly:
          this.style.value = ZeekrLogoStyle.horizontal;
        case ZeekrLogoStyle.horizontal:
          this.style.value = ZeekrLogoStyle.stacked;
        case ZeekrLogoStyle.stacked:
          this.style.value = ZeekrLogoStyle.markOnly;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return ValueListenableBuilder(
      valueListenable: style,
      builder: (context, style, child) {
        return ZeekrLogo(
          style: style,
          color: theme.textTheme.textStyle.color!,
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
