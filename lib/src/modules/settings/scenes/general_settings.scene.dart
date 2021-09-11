import 'package:flutter/material.dart';
import 'package:i18next/i18next.dart';
import 'package:sidekick/i18n/language_manager.dart';

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
            title: Text(I18Next.of(context)
                .t('modules:settings.scenes.areYouSureYouWantToResetSettings')),
            content: Text(
              I18Next.of(context).t(
                  'modules:settings.scenes.thisWillOnlyResetSidekickSpecificPreferences'),
            ),
            buttonPadding: const EdgeInsets.all(15),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child:
                    Text(I18Next.of(context).t('modules:fvm.dialogs.cancel')),
              ),
              TextButton(
                key: Key('tb_confirm'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  settings.sidekick = SidekickSettings();
                  onSave();
                  notify(I18Next.of(context)
                      .t('modules:settings.scenes.appSettingsHaveBeenReset'));
                },
                child:
                    Text(I18Next.of(context).t('modules:fvm.dialogs.confirm')),
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
          Text(I18Next.of(context).t('modules:settings.scenes.general'),
              style: Theme.of(context).textTheme.headline6),
          const SizedBox(height: 20),
          ListTile(
            title: Text(
              I18Next.of(context).t('modules:settings.scenes.theme'),
            ),
            subtitle: Text(
              I18Next.of(context).t(
                  'modules:settings.scenes.selectAThemeOrSwitchAccordingToSystemSettings'),
            ),
            trailing: DropdownButton(
              key: Key('db_theme'),
              underline: Container(),
              isDense: true,
              value: settings.sidekick.themeMode.toString(),
              items: [
                DropdownMenuItem(
                  key: Key('dmi_system'),
                  value: SettingsThemeMode.system,
                  child: Text(
                      I18Next.of(context).t('modules:settings.scenes.system')),
                ),
                DropdownMenuItem(
                  key: Key('dmi_light'),
                  value: SettingsThemeMode.light,
                  child: Text(
                      I18Next.of(context).t('modules:settings.scenes.light')),
                ),
                DropdownMenuItem(
                  key: Key('dmi_dark'),
                  value: SettingsThemeMode.dark,
                  child: Text(
                      I18Next.of(context).t('modules:settings.scenes.dark')),
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
            title: Text(
              I18Next.of(context).t('modules:settings.scenes.ideSelection'),
            ),
            subtitle: Text(
              I18Next.of(context).t(
                  'modules:settings.scenes.whatIdeDoYouWantToOpenYourProjectsWith'),
            ),
            trailing: DropdownButton(
              underline: Container(),
              isDense: true,
              value: settings.sidekick.ide ?? 'none',
              items: [
                DropdownMenuItem(
                  value: 'none',
                  child: Text('None'),
                ),
                ...supportedIDEs
                    .map((e) => DropdownMenuItem(
                          value: e.name,
                          child: Row(
                            children: [
                              e.icon,
                              SizedBox(
                                width: 10,
                              ),
                              Text(e.name),
                            ],
                          ),
                        ))
                    .toList()
              ],
              onChanged: (val) async {
                settings.sidekick.ide = (val == 'none' ? null : val);
                onSave();
              },
            ),
          ),
          const Divider(),
          ListTile(
            title:
                Text(I18Next.of(context).t('modules:settings.scenes.language')),
            trailing: DropdownButton<Locale>(
              key: Key('db_locale'),
              underline: Container(),
              isDense: true,
              value: settings.sidekick.locale ?? I18Next.of(context).locale,
              items: languageManager.supportedLocales.map((locale) {
                return DropdownMenuItem(
                  key: Key('dmi_${locale.toLanguageTag()}'),
                  value: locale,
                  child: Text(
                    I18Next.of(context).t(
                      'settings:sidekick.language.${locale.toLanguageTag()}',
                    ),
                  ),
                );
              }).toList(),
              onChanged: (Locale locale) async {
                settings.sidekick.locale = locale;
                onSave();
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(I18Next.of(context)
                .t('modules:selectedDetail.components.version')),
            trailing: Text(packageVersion),
          ),
          const Divider(),
          ListTile(
            title: Text(I18Next.of(context)
                .t('modules:settings.scenes.resetToDefaultSettings')),
            trailing: OutlinedButton(
              key: Key('ob_reset'),
              onPressed: handleReset,
              child:
                  Text(I18Next.of(context).t('modules:settings.scenes.reset')),
            ),
          ),
        ],
      ),
    );
  }
}
