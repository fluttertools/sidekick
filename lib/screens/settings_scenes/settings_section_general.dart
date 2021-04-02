import 'package:flutter/material.dart';
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
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: ListView(
        children: [
          Text('General', style: Theme.of(context).textTheme.headline6),
          const SizedBox(height: 20),
          SettingsTile(
            title: "Theme",
            leading: const Icon(Icons.color_lens_rounded),
            trailing: DropdownButton(
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
              onChanged: (themeMode) {
                settings.sidekick.themeMode = themeMode;
                onSave();
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
