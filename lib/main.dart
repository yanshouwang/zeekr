import 'package:flutter/cupertino.dart';

import 'ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Zeekr',
      onGenerateTitle: (context) => 'Zeekr',
      home: const HomeView(),
    );
  }
}
