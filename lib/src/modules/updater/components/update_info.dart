import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';
import 'package:sidekick/src/modules/updater/components/update.dialog.dart';

import '../../../version.dart';
import '../updater.provider.dart';

/// Sidekick version info
class SkUpdateInfo extends ConsumerWidget {
  /// Constructor
  const SkUpdateInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updater = ref.watch(updaterProvider.notifier);
    final updateInfo = ref.watch(updaterProvider);

    if (updateInfo.ready) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const UpdateDialog(),
              );
            },
            icon: const Icon(Icons.download_rounded),
            label: Text(
              "${context.i18n('modules:updater.components.updateAvailable')} (${updateInfo.latest})",
            ),
          ),
          const SizedBox(width: 10),
          const Text(packageVersion),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 5),
        const Text(packageVersion),
        const SizedBox(width: 20),
        Text(updateInfo.latest),
        const SizedBox(width: 20),
        OutlinedButton.icon(
          icon: Icon(
            updateInfo.needUpdate ? Icons.file_download : Icons.refresh,
          ),
          label: Text(context.i18n('components:atoms.refresh')),
          onPressed: updater.checkLatest,
        ),
      ],
    );
  }
}
