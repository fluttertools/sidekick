import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';
import 'package:sidekick/src/modules/updater/updater.provider.dart';

import '../../../components/atoms/typography.dart';

class UpdateDialog extends HookWidget {
  const UpdateDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final updateInfo = useProvider(updaterProvider);
    final updater = useProvider(updaterProvider.notifier);

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      buttonPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      title: Column(
        children: [
          Icon(
            MdiIcons.alertDecagram,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(height: 10),
          Text(context.i18n('modules:updater.components.updateAvailable'),
              style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
      content: Text(
        context.i18n(
          'modules:updater.components.sidekickVersionUpdateinfolatestIsNowAvailable',
          variables: {
            'updateInfoLatest': updateInfo.latest,
          },
        ),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.i18n('modules:updater.components.later')),
        ),
        TextButton(
          onPressed: () async {
            await updater.openInstaller(context);
            Navigator.of(context).pop();
          },
          child: Text(context.i18n('modules:updater.components.updateNow')),
        ),
      ],
    );
  }
}
