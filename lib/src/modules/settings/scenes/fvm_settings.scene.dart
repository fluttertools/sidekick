import 'package:flutter/material.dart';

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
            title: Text(I18Next.of(context).t.skipSetupFlutterOnInstall),
            subtitle: Text(I18Next.of(context)
                    .t
                    .thisWillOnlyCloneFlutterAndNotInstall +
                I18Next.of(context).t.dependenciesAfterANewVersionIsInstalled),
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
