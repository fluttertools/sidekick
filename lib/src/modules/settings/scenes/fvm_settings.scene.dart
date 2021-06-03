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
            title: const Text('Git Cache'),
            subtitle: const Text('This will cache the main Flutter repository'
                ' for faster and smaller installs'),
            value: settings.fvm.gitCache ?? false,
            onChanged: (value) {
              settings.fvm.gitCache = value;
              onSave();
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Skip setup Flutter on install'),
            subtitle: const Text('This will only clone Flutter and not install'
                'dependencies after a new version is installed.'),
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
