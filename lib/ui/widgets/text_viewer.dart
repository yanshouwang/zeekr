import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';

class TextViewer extends StatefulWidget {
  final XFile file;
  final Encoding encoding;
  final TextStyle? style;

  const TextViewer({
    super.key,
    required this.file,
    this.encoding = utf8,
    this.style,
  });

  @override
  State<TextViewer> createState() => _TextViewerState();
}

class _TextViewerState extends State<TextViewer> {
  late final ValueNotifier<bool> isLoading;
  late final ValueNotifier<List<String>?> lines;

  @override
  void initState() {
    super.initState();
    isLoading = ValueNotifier(false);
    lines = ValueNotifier(null);

    _loadLines();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    return ListenableBuilder(
      listenable: Listenable.merge([isLoading, lines]),
      builder: (context, child) {
        final isLoading = this.isLoading.value;
        final lines = this.lines.value;
        if (isLoading) {
          return Center(child: CupertinoActivityIndicator());
        } else if (lines == null || lines.isEmpty) {
          return Center(child: Text('No lines', style: style));
        } else {
          return ListView.builder(
            itemBuilder: (context, i) {
              final line = lines[i];
              return Text(line, style: style);
            },
            itemCount: lines.length,
          );
        }
      },
    );
  }

  @override
  void didUpdateWidget(covariant TextViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file != widget.file ||
        oldWidget.encoding != widget.encoding) {
      _loadLines();
    }
  }

  @override
  void dispose() {
    isLoading.dispose();
    lines.dispose();
    super.dispose();
  }

  void _loadLines() async {
    isLoading.value = true;
    try {
      final file = widget.file;
      final encoding = widget.encoding;
      const lineSplitter = LineSplitter();
      lines.value =
          await file
              .openRead()
              .cast<List<int>>()
              .transform(encoding.decoder)
              .transform(lineSplitter)
              .toList();
    } finally {
      isLoading.value = false;
    }
  }
}
