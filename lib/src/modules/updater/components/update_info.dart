import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../version.dart';
import '../updater.provider.dart';

/// Sidekick version info
class SkUpdateInfo extends HookWidget {
  /// Constructor
  const SkUpdateInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final updater = useProvider(updaterProvider.notifier);
    final updateInfo = useProvider(updaterProvider);

    if (updateInfo.ready) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'A new version of Sidekick is available (${updateInfo.latest}).',
          ),
          const SizedBox(width: 5),
          TextButton(
            child: const Text('Click here to download.'),
            onPressed: () {},
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 5),
        const Text(packageVersion),
        const SizedBox(width: 20),
        Text("${updateInfo.latest}"),
        const SizedBox(width: 20),
        OutlinedButton.icon(
          icon: Icon(
            updateInfo.needUpdate ? Icons.file_download : Icons.refresh,
          ),
          label: Text("Refresh"),
          onPressed: updater.checkLatest,
        ),
      ],
    );
  }
}
