import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/notify.dart';

class CopyButton extends StatelessWidget {
  final String content;
  const CopyButton(this.content, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 20,
      splashRadius: 20,
      icon: const Icon(Icons.content_copy),
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: content));
        notify('Copied to clipboard');
      },
    );
  }
}
