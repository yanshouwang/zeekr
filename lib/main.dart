import 'package:flutter/material.dart';

import 'ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zeekr',
      onGenerateTitle: (context) => 'Zeekr',
      home: const HomeView(),
    );
  }
}
