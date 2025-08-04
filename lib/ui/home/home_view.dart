import 'package:flutter/cupertino.dart';

import 'animated_zeekr_logo.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          heightFactor: 0.5,
          child: AnimatedZeekrLogo(),
        ),
      ),
    );
  }
}
