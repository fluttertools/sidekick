import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:sidekick/i18n/language_manager.dart';
import 'package:sidekick/src/components/atoms/typography.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';
import 'package:sidekick/src/modules/updater/components/update_info.dart';

import '../../../modules/common/utils/notify.dart';
import '../settings.dto.dart';
import '../settings.utils.dart';

/// Settings section general
class SettingsSectionGeneral extends StatelessWidget {
  /// Constructor
  const SettingsSectionGeneral(
    this.settings,
    this.onSave, {
    Key? key,
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
            title: Row(
              children: [
                const Icon(Icons.warning),
                const SizedBox(width: 10),
                Heading(context.i18n(
                    'modules:settings.scenes.areYouSureYouWantToResetSettings')),
              ],
            ),
            content: Text(
              context.i18n(
                  'modules:settings.scenes.thisWillOnlyResetSidekickSpecificPreferences'),
            ),
            buttonPadding: const EdgeInsets.all(15),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(context.i18n('modules:fvm.dialogs.cancel')),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  settings.sidekick = SidekickSettings();
                  onSave();
                  notify(context.i18n(
                      'modules:settings.scenes.appSettingsHaveBeenReset'));
                },
                child: Text(context.i18n('modules:fvm.dialogs.confirm')),
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
          Text(context.i18n('modules:settings.scenes.general'),
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          ListTile(
            title: Text(
              context.i18n('modules:settings.scenes.theme'),
            ),
            subtitle: Text(
              context.i18n(
                  'modules:settings.scenes.selectAThemeOrSwitchAccordingToSystemSettings'),
            ),
            trailing: DropdownButton(
              underline: Container(),
              isDense: false,
              borderRadius: BorderRadius.circular(10),
              value: settings.sidekick.themeMode.toString(),
              items: [
                DropdownMenuItem(
                  value: SettingsThemeMode.system,
                  child: Text(context.i18n('modules:settings.scenes.system')),
                ),
                DropdownMenuItem(
                  value: SettingsThemeMode.light,
                  child: Text(context.i18n('modules:settings.scenes.light')),
                ),
                DropdownMenuItem(
                  value: SettingsThemeMode.dark,
                  child: Text(context.i18n('modules:settings.scenes.dark')),
                ),
              ],
              onChanged: (themeMode) async {
                settings.sidekick.themeMode = themeMode as String;
                onSave();
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              context.i18n('modules:settings.scenes.ideSelection'),
            ),
            subtitle: Text(
              context.i18n(
                  'modules:settings.scenes.whatIdeDoYouWantToOpenYourProjectsWith'),
            ),
            trailing: DropdownButton(
              underline: Container(),
              isDense: false,
              borderRadius: BorderRadius.circular(10),
              value: settings.sidekick.ide ?? 'none',
              items: [
                const DropdownMenuItem(
                  value: 'none',
                  child: Text('None'),
                ),
                ...supportedIDEs
                    .map((e) => DropdownMenuItem(
                          value: e.name,
                          child: Row(
                            children: [
                              e.icon,
                              const SizedBox(
                                width: 10,
                              ),
                              Text(e.name),
                            ],
                          ),
                        ))
                    .toList()
              ],
              onChanged: (val) async {
                if (val == "Custom") {
                  final file = await openFile();
                  if (file != null) {
                    settings.sidekick.customIdeLocation = file.path;
                  } else {
                    return;
                  }
                }
                settings.sidekick.ide = val == 'none' ? null : val as String;
                onSave();
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(context.i18n('modules:settings.scenes.language')),
            trailing: DropdownButton<Locale>(
              underline: Container(),
              isDense: false,
              borderRadius: BorderRadius.circular(10),
              value: settings.sidekick.locale ?? context.locale,
              items: languageManager.supportedLocales.map((locale) {
                return DropdownMenuItem(
                  value: locale,
                  child: Text(
                    context.i18n(
                      'settings:sidekick.language.${locale.toLanguageTag()}',
                    ),
                  ),
                );
              }).toList(),
              onChanged: (locale) async {
                settings.sidekick.locale = locale;
                onSave();
              },
            ),
          ),
          const Divider(),
          ListTile(
            title:
                Text(context.i18n('modules:selectedDetail.components.version')),
            trailing: const SkUpdateInfo(),
          ),
          const Divider(),
          ListTile(
            title: Text(
                context.i18n('modules:settings.scenes.resetToDefaultSettings')),
            trailing: OutlinedButton(
              onPressed: handleReset,
              child: Text(context.i18n('modules:settings.scenes.reset')),
            ),
          ),
        ],
      ),
    );
  }
}
