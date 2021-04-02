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
          SettingsTile.switchTile(
            title: 'Git Cache',
            subtitle: "This will cache the main Flutter repository"
                " for faster and smaller installs",
            leading: const Icon(MdiIcons.git),
            switchActiveColor: Theme.of(context).accentColor,
            switchValue: settings.fvm.gitCache ?? false,
            subtitleTextStyle: Theme.of(context).textTheme.caption,
            onToggle: (value) {
              settings.fvm.gitCache = value;
              onSave();
            },
          ),
          const Divider(),
          SettingsTile.switchTile(
            title: 'Skip setup Flutter on install',
            subtitle: "This will only clone Flutter and not install"
                "dependencies after a new version is installed.",
            leading: const Icon(MdiIcons.cogSync),
            switchActiveColor: Theme.of(context).accentColor,
            subtitleTextStyle: Theme.of(context).textTheme.caption,
            switchValue: settings.fvm.skipSetup ?? false,
            onToggle: (value) {
              settings.fvm.skipSetup = value;
              onSave();
            },
          ),
        ],
      ),
    );
  }
}
