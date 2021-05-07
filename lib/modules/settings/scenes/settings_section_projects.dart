import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:truncate/truncate.dart';

import '../settings.provider.dart';

class SettingsSectionProjects extends StatelessWidget {
  final Settings settings;
  final Function() onSave;

  const SettingsSectionProjects(
    this.settings,
    this.onSave, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasProjectPath = settings.sidekick.firstProjectDir != null;

    Future<void> handleChooseDirectory() async {
      final directoryPath = await getDirectoryPath(confirmButtonText: 'Choose');
      if (directoryPath == null) {
        // Operation was canceled by the user.
        return;
      }
      // Save if a path is selected
      settings.sidekick.firstProjectDir = directoryPath;
      await onSave();
    }

    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: ListView(
        children: [
          Text('Projects', style: Theme.of(context).textTheme.headline6),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Projects Directory'),
            subtitle: const Text(
              'Directory which Sidekick will look for Flutter projects.',
            ),
            trailing: TextButton(
              onPressed: handleChooseDirectory,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      truncate(
                          hasProjectPath
                              ? settings.sidekick.firstProjectDir
                              : 'Choose',
                          20,
                          position: TruncatePosition.middle),
                    ),
                    const Icon(MdiIcons.menuDown),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Only FVM configured'),
            subtitle: const Text(
              'Will display only projects that have FVM configured.',
            ),
            value: settings.sidekick.onlyProjectsWithFvm,
            onChanged: (value) {
              settings.sidekick.onlyProjectsWithFvm = value;
              onSave();
            },
          )
        ],
      ),
    );
  }
}
