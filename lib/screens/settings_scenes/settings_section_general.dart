import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sidekick/dto/settings.dto.dart';
import 'package:sidekick/providers/settings.provider.dart';
import 'package:sidekick/utils/get_theme_mode.dart';
import 'package:sidekick/utils/notify.dart';
import 'package:sidekick/version.dart';

class SettingsSectionGeneral extends StatelessWidget {
  final Settings settings;
  final void Function() onSave;

  const SettingsSectionGeneral(
    this.settings,
    this.onSave, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void handleReset() async {
      // flutter defined function
      showDialog(
        context: context,
        builder: (context) {
          // return object of type Dialog
          return AlertDialog(
            title: const Text("Are you sure you want to reset settings?"),
            content: const Text(
              'This will only reset Sidekick specific preferences',
            ),
            buttonPadding: const EdgeInsets.all(15),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Confirm"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  settings.sidekick = SidekickSettings();
                  onSave();
                  notify('App settings have been reset');
                },
              ),
            ],
          );
        },
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: ListView(
        children: [
          Text('General', style: Theme.of(context).textTheme.headline6),
          const SizedBox(height: 20),
          SettingsTile.switchTile(
            title: "Advanced Mode",
            subtitle: 'Enables more advanced and experimental functionality.',
            leading: const Icon(MdiIcons.fire),
            switchValue: settings.sidekick.advancedMode,
            titleTextStyle: Theme.of(context).textTheme.bodyText1,
            switchActiveColor: Theme.of(context).accentColor,
            subtitleTextStyle: Theme.of(context).textTheme.caption,
            onToggle: (value) {
              settings.sidekick.advancedMode = value;
              onSave();
            },
          ),
          const Divider(),
          SettingsTile(
            title: "Theme",
            titleTextStyle: Theme.of(context).textTheme.bodyText1,
            leading: const Icon(Icons.color_lens_rounded),
            trailing: DropdownButton(
              underline: Container(),
              isDense: true,
              value: settings.sidekick.themeMode.toString(),
              items: const [
                DropdownMenuItem(
                  child: Text("System"),
                  value: SettingsThemeMode.system,
                ),
                DropdownMenuItem(
                  child: Text("Light"),
                  value: SettingsThemeMode.light,
                ),
                DropdownMenuItem(
                  child: Text("Dark"),
                  value: SettingsThemeMode.dark,
                ),
              ],
              onChanged: (themeMode) async {
                settings.sidekick.themeMode = themeMode;
                onSave();
              },
            ),
          ),
          const Divider(),
          SettingsTile(
            title: "App version",
            titleTextStyle: Theme.of(context).textTheme.bodyText1,
            leading: const Icon(Icons.info_outline_rounded),
            trailing: const Text(appVersion),
          ),
          const Divider(),
          SettingsTile(
            title: "Reset to default settings",
            leading: const Icon(MdiIcons.backupRestore),
            trailing: OutlinedButton(
              onPressed: (handleReset),
              child: const Text('Reset'),
            ),
          ),
        ],
      ),
    );
  }
}
