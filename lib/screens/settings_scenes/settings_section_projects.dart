import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:settings_ui/settings_ui.dart';
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
          SettingsTile(
            title: 'Projects Directory',
            subtitle:
                'Directory which Sidekick will look for Flutter projects.',
            subtitleTextStyle: Theme.of(context).textTheme.caption,
            trailing: TextButton(
              onPressed: handleChooseDirectory,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      truncate(settings.sidekick.firstProjectDir, 20,
                          position: TruncatePosition.middle),
                    ),
                    const Icon(MdiIcons.menuDown),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          SettingsTile.switchTile(
            title: 'Only FVM configured',
            subtitle: 'Will display only projects that have FVM configured.',
            titleTextStyle: Theme.of(context).textTheme.bodyText1,
            switchActiveColor: Theme.of(context).accentColor,
            subtitleTextStyle: Theme.of(context).textTheme.caption,
            switchValue: settings.sidekick.onlyProjectsWithFvm,
            onToggle: (value) {
              settings.sidekick.onlyProjectsWithFvm = value;
              onSave();
            },
          )
        ],
      ),
    );
  }
}
