import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:zeekr/ui/widgets.dart';

class XLogView extends StatefulWidget {
  const XLogView({super.key});

  @override
  State<XLogView> createState() => _XLogViewState();
}

class _XLogViewState extends State<XLogView> {
  late final ValueNotifier<XFile?> file;

  @override
  void initState() {
    super.initState();
    file = ValueNotifier(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: ValueListenableBuilder(
          valueListenable: file,
          builder: (context, file, child) {
            final title = file?.name ?? 'XLog';
            return Text(title);
          },
        ),
        trailing: CupertinoButton(
          child: Icon(CupertinoIcons.tray),
          onPressed: () async {
            final typeGroup = XTypeGroup(label: 'txts', extensions: ['txt']);
            final file = await openFile(acceptedTypeGroups: [typeGroup]);
            if (file == null) {
              return;
            }
            this.file.value = file;
          },
        ),
      ),
      child: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: file,
          builder: (context, file, child) {
            return file == null
                ? Container()
                : TextViewer(file: file, style: theme.textTheme.textStyle);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    file.dispose();
    super.dispose();
  }
}
