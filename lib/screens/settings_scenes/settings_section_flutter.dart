import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sidekick/providers/settings.provider.dart';

class SettingsSectionFlutter extends StatelessWidget {
  final Settings settings;
  final Function() onSave;

  const SettingsSectionFlutter(
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
          Text('Flutter', style: Theme.of(context).textTheme.headline6),
          const SizedBox(height: 20),
          SettingsSection(
            title: 'Analytics',
            tiles: [
              SettingsTile.switchTile(
                title: 'Disable tracking',
                subtitle: "This will disable Flutter analytics",
                leading: const Icon(MdiIcons.googleAnalytics),
                switchActiveColor: Theme.of(context).accentColor,
                switchValue: !settings.flutter.analytics,
                subtitleTextStyle: Theme.of(context).textTheme.caption,
                onToggle: (value) {
                  settings.flutter.analytics = !value;
                  onSave();
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Platforms',
            tiles: [
              SettingsTile.switchTile(
                title: 'Web',
                leading: const Icon(MdiIcons.googleChrome),
                titleTextStyle: Theme.of(context).textTheme.bodyText1,
                switchActiveColor: Theme.of(context).accentColor,
                subtitleTextStyle: Theme.of(context).textTheme.caption,
                switchValue: settings.flutter.web,
                onToggle: (value) {
                  settings.flutter.web = value;
                  onSave();
                },
              ),
              SettingsTile.switchTile(
                title: 'MacOS',
                leading: const Icon(MdiIcons.apple),
                titleTextStyle: Theme.of(context).textTheme.bodyText1,
                switchActiveColor: Theme.of(context).accentColor,
                switchValue: settings.flutter.macos,
                subtitleTextStyle: Theme.of(context).textTheme.caption,
                onToggle: (value) {
                  settings.flutter.macos = value;
                  onSave();
                },
              ),
              SettingsTile.switchTile(
                title: 'Windows',
                leading: const Icon(MdiIcons.microsoftWindows),
                titleTextStyle: Theme.of(context).textTheme.bodyText1,
                switchActiveColor: Theme.of(context).accentColor,
                switchValue: settings.flutter.windows,
                subtitleTextStyle: Theme.of(context).textTheme.caption,
                onToggle: (value) {
                  settings.flutter.windows = value;
                  onSave();
                },
              ),
              SettingsTile.switchTile(
                title: 'Linux',
                leading: const Icon(MdiIcons.linux),
                titleTextStyle: Theme.of(context).textTheme.bodyText1,
                switchActiveColor: Theme.of(context).accentColor,
                switchValue: settings.flutter.linux,
                subtitleTextStyle: Theme.of(context).textTheme.caption,
                onToggle: (value) {
                  settings.flutter.linux = value;
                  onSave();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
