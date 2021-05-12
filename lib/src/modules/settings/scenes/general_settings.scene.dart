import 'package:flutter/material.dart';

import '../../../modules/common/utils/notify.dart';
import '../../../version.dart';
import '../settings.dto.dart';
import '../settings.utils.dart';

/// Settings section general
class SettingsSectionGeneral extends StatelessWidget {
  /// Constructor
  const SettingsSectionGeneral(
    this.settings,
    this.onSave, {
    Key key,
  }) : super(key: key);

  /// Settings
  final AllSettings settings;

  /// On save handler
  final void Function() onSave;

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
          ListTile(
            title: const Text("Theme"),
            subtitle: const Text(
              'Select a theme or switch according to system settings..',
            ),
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
          const ListTile(
            title: Text('Version'),
            trailing: Text(packageVersion),
          ),
          const Divider(),
          ListTile(
            title: const Text('Reset to default settings'),
            trailing: OutlinedButton(
              onPressed: handleReset,
              child: const Text('Reset'),
            ),
          ),
        ],
      ),
    );
  }
}
