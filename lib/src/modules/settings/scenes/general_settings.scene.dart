import 'package:flutter/material.dart';
import 'package:sidekick/generated/l10n.dart';

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
      await showDialog(
        context: context,
        builder: (context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(S.of(context).areYouSureYouWantToResetSettings),
            content: Text(
              S.of(context).thisWillOnlyResetSidekickSpecificPreferences,
            ),
            buttonPadding: const EdgeInsets.all(15),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(S.of(context).cancel),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  settings.sidekick = SidekickSettings();
                  onSave();
                  notify(S.of(context).appSettingsHaveBeenReset);
                },
                child: Text(S.of(context).confirm),
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
          Text(S.of(context).general,
              style: Theme.of(context).textTheme.headline6),
          const SizedBox(height: 20),
          ListTile(
            title: Text(S.of(context).theme),
            subtitle: Text(
              S.of(context).selectAThemeOrSwitchAccordingToSystemSettings,
            ),
            trailing: DropdownButton(
              underline: Container(),
              isDense: true,
              value: settings.sidekick.themeMode.toString(),
              items: [
                DropdownMenuItem(
                  value: SettingsThemeMode.system,
                  child: Text(S.of(context).system),
                ),
                DropdownMenuItem(
                  value: SettingsThemeMode.light,
                  child: Text(S.of(context).light),
                ),
                DropdownMenuItem(
                  value: SettingsThemeMode.dark,
                  child: Text(S.of(context).dark),
                ),
              ],
              onChanged: (themeMode) async {
                settings.sidekick.themeMode = themeMode;
                onSave();
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(S.of(context).language),
            trailing: DropdownButton(
              underline: Container(),
              isDense: true,
              value: settings.sidekick.intl ?? 'en',
              items: S.delegate.supportedLocales.map((e) {
                return DropdownMenuItem(
                  value: e.languageCode,
                  child: Text(e.languageCode),
                );
              }).toList(),
              onChanged: (languageCode) async {
                settings.sidekick.intl = languageCode;
                await S.load(
                  Locale.fromSubtags(languageCode: languageCode),
                );
                onSave();
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(S.of(context).version),
            trailing: Text(packageVersion),
          ),
          const Divider(),
          ListTile(
            title: Text(S.of(context).resetToDefaultSettings),
            trailing: OutlinedButton(
              onPressed: handleReset,
              child: Text(S.of(context).reset),
            ),
          ),
        ],
      ),
    );
  }
}
