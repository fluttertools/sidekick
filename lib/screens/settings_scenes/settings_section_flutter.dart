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
            title: 'Disable tracking',
            subtitle: "This will disable Google's crash reporting"
                "and analytics, when installing a new version",
            leading: const Icon(MdiIcons.bug),
            switchActiveColor: Theme.of(context).accentColor,
            switchValue: settings.flutterAnalyticsEnabled ?? false,
            subtitleTextStyle: Theme.of(context).textTheme.caption,
            onToggle: (value) {
              settings.flutterAnalyticsEnabled = value;
              onSave();
            },
          ),
        ],
      ),
    );
  }
}
