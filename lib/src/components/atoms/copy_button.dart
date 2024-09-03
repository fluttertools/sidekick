import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';
import 'package:sidekick/src/modules/common/utils/notify.dart';

/// Copy button
class CopyButton extends HookWidget {
  /// Constructor
  const CopyButton(
    this.content, {
    super.key,
  });

  /// Content to copy
  final String content;
  @override
  Widget build(BuildContext context) {
    final isMounted = context.mounted;
    return IconButton(
      iconSize: 20,
      splashRadius: 20,
      icon: const Icon(Icons.content_copy),
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: content));
        if (isMounted) {
          // ignore: use_build_context_synchronously
          notify(context.i18n('components:atoms.copiedToClipboard'));
        }
      },
    );
  }
}
