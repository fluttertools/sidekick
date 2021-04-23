import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/providers/settings.provider.dart';
import 'package:truncate/truncate.dart';

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
      final fileResult = await showOpenPanel(
        allowedFileTypes: [],
        canSelectDirectories: true,
      );

      // Save if a path is selected
      if (fileResult.paths.isNotEmpty) {
        settings.sidekick.firstProjectDir = fileResult.paths.single;
      }

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
