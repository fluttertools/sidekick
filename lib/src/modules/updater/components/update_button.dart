import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';
import 'package:sidekick/src/modules/updater/components/update.dialog.dart';

import '../updater.provider.dart';

/// Sidekick update button
class SkUpdateButton extends ConsumerWidget {
  /// Constructor
  const SkUpdateButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updater = ref.watch(updaterProvider.notifier);
    final updateInfo = ref.watch(updaterProvider);

    /// Return empty if its not installed or does not need update
    if (!updateInfo.ready) {
      return const SizedBox(height: 0, width: 0);
    }

    void showUpdateDialog() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (context) {
          // return object of type Dialog
          return const UpdateDialog();
        },
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ActionChip(
          onPressed: showUpdateDialog,
          label: Text(
            context.i18n('modules:updater.components.updateAvailable'),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
