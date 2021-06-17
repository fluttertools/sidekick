import 'package:flutter/material.dart';
import 'package:sidekick/generated/l10n.dart';

import '../settings.dto.dart';

/// Fvm Settings Scene
class FvmSettingsScene extends StatelessWidget {
  /// Constructor
  const FvmSettingsScene(
    this.settings,
    this.onSave, {
    Key key,
  }) : super(key: key);

  /// Settings
  final AllSettings settings;

  /// Save handler
  final Function() onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: ListView(
        children: [
          Text('FVM', style: Theme.of(context).textTheme.headline6),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Git Cache'),
            subtitle: Text(S.of(context).thisWillCacheTheMainFlutterRepository +
                S.of(context).forFasterAndSmallerInstalls),
            value: settings.fvm.gitCache ?? false,
            onChanged: (value) {
              settings.fvm.gitCache = value;
              onSave();
            },
          ),
          const Divider(),
          SwitchListTile(
            title: Text(S.of(context).skipSetupFlutterOnInstall),
            subtitle: Text(S.of(context).thisWillOnlyCloneFlutterAndNotInstall +
                S.of(context).dependenciesAfterANewVersionIsInstalled),
            value: settings.fvm.skipSetup ?? false,
            onChanged: (value) {
              settings.fvm.skipSetup = value;
              onSave();
            },
          ),
        ],
      ),
    );
  }
}
