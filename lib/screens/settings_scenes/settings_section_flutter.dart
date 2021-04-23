import 'package:flutter/material.dart';
import 'package:sidekick/components/atoms/typography.dart';
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
          SwitchListTile(
            title: const Text('Analytics & Crash Reporting'),
            subtitle: const Text("When a flutter command crashes it attempts"
                " to send a crash report to Google in order to help"
                " Google contribute improvements to Flutter over time"),
            value: !settings.flutter.analytics,
            onChanged: (value) {
              settings.flutter.analytics = !value;
              onSave();
            },
          ),
          const SizedBox(height: 20),
          const Subheading('Platforms'),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Web'),
            value: settings.flutter.web,
            onChanged: (value) {
              settings.flutter.web = value;
              onSave();
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('MacOS'),
            value: settings.flutter.macos,
            onChanged: (value) {
              settings.flutter.macos = value;
              onSave();
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Windows'),
            value: settings.flutter.windows,
            onChanged: (value) {
              settings.flutter.windows = value;
              onSave();
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Linux'),
            value: settings.flutter.linux,
            onChanged: (value) {
              settings.flutter.linux = value;
              onSave();
            },
          ),
        ],
      ),
    );
  }
}
