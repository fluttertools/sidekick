import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sidekick/providers/settings.provider.dart';
import 'package:sidekick/utils/get_theme_mode.dart';
import 'package:sidekick/version.dart';

class SettingsSectionGeneral extends StatelessWidget {
  final Settings settings;
  final Function() onSave;

  const SettingsSectionGeneral(
    this.settings,
    this.onSave, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dialog to confirm theme change
    Future<void> changeThemeDialog() {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Changing theme will close your settings screen"),
          buttonPadding: const EdgeInsets.all(15),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            TextButton(
              child: const Text("OK"),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
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
                await changeThemeDialog();

                Navigator.of(context).pop();
              },
            ),
          ),
          const Divider(),
          const SettingsTile(
            title: "App version",
            leading: Icon(Icons.info_outline_rounded),
            trailing: Text(appVersion),
          ),
        ],
      ),
    );
  }
}
