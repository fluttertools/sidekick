import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';
import 'package:sidekick/src/modules/common/utils/notify.dart';

/// Copy button
class CopyButton extends StatelessWidget {
  /// Constructor
  const CopyButton(
    this.content, {
    Key? key,
  }) : super(key: key);

  /// Content to copy
  final String content;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 20,
      splashRadius: 20,
      icon: const Icon(Icons.content_copy),
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: content));
        notify(context.i18n('components:atoms.copiedToClipboard'));
      },
    );
  }
}
