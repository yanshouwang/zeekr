import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zeekr/ui.dart';

// import 'animated_flutter_logo.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(16.0),
        // child: FractionallySizedBox(
        //   widthFactor: 0.5,
        //   heightFactor: 0.5,
        //   child: AnimatedFlutterLogo(),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16.0,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text('子网掩码'),
              ),
              inputFormatters: [
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final oldText = oldValue.text;
                  final oldSelection = oldValue.selection;
                  final oldBefore = oldSelection.textBefore(oldText);
                  final oldInside = oldSelection.textInside(oldText);
                  final oldAfter = oldSelection.textAfter(oldText);
                  debugPrint(
                    'oldValue[$oldText]: $oldBefore, $oldInside, $oldAfter',
                  );
                  final newText = newValue.text;
                  final newSelection = newValue.selection;
                  final newBefore = newSelection.textBefore(newText);
                  final newInside = newSelection.textInside(newText);
                  final newAfter = newSelection.textAfter(newText);
                  debugPrint(
                    'newValue[$newText]: $newBefore, $newInside, $newAfter',
                  );
                  assert(newValue.selection.isCollapsed);
                  assert(newValue.composing.isCollapsed);
                  return newValue;
                }),
              ],
            ),
            IpAddressField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text('子网掩码'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
