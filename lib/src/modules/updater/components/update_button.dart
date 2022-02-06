import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18next/i18next.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';

import '../../../components/atoms/typography.dart';
import '../updater.provider.dart';

/// Sidekick update button
class SkUpdateButton extends HookWidget {
  /// Constructor
  const SkUpdateButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final updater = useProvider(updaterProvider.notifier);
    final updateInfo = useProvider(updaterProvider);

    /// Return empty if its not installed or does not need update
    if (updateInfo == null || !updateInfo.ready) {
      return const SizedBox(height: 0, width: 0);
    }

    void showUpdateDialog() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (context) {
          // return object of type Dialog
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            buttonPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            title: Row(
              children: [
                const Icon(MdiIcons.alertDecagram),
                const SizedBox(width: 10),
                Heading(I18Next.of(context)
                    .t('modules:updater.components.updateAvailable')),
              ],
            ),
            content: Paragraph(
              context.i18n(
                'modules:updater.components.sidekickVersionUpdateinfolatestIsNowAvailable',
                variables: {
                  'updateInfoLatest': updateInfo.latest,
                },
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(context.i18n('modules:updater.components.later')),
              ),
              ElevatedButton(
                onPressed: () async {
                  await updater.openInstaller(context);
                  Navigator.of(context).pop();
                },
                child: Text(I18Next.of(context)
                    .t('modules:updater.components.updateNow')),
              ),
            ],
          );
        },
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ActionChip(
          onPressed: showUpdateDialog,
          label: Text(
            I18Next.of(context).t('modules:updater.components.updateAvailable'),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
