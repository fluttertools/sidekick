import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/modules/flutter_releases/flutter_releases.provider.dart';
import 'package:sidekick/modules/settings/settings.provider.dart';

class SettingsSectionFlutter extends HookWidget {
  final Settings settings;
  final Function() onSave;

  const SettingsSectionFlutter(
    this.settings,
    this.onSave, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final releases = useProvider(releasesStateProvider);

    final deactivate = !releases.hasGlobal;

    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: CupertinoScrollbar(
        child: ListView(
          children: [
            Text('Flutter', style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 20),
            releases.hasGlobal
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // TODO: Move this into a separate component
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.withOpacity(0.1),
                          border: Border.all(
                            color: Colors.deepOrange,
                            width: 0.5,
                          ),
                        ),
                        child: const Text(
                          'A Flutter sdk version neeeds to be set as global '
                          'in order to access Flutter settings',
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
            SwitchListTile(
              title: const Text('Analytics & Crash Reporting'),
              subtitle: const Text(
                "When a flutter command crashes it attempts"
                " to send a crash report to Google in order to help"
                " Google contribute improvements to Flutter over time",
              ),
              value: !settings.flutter.analytics,
              onChanged: deactivate
                  ? null
                  : (value) {
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
              onChanged: deactivate
                  ? null
                  : (value) {
                      settings.flutter.web = value;
                      onSave();
                    },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('MacOS'),
              value: settings.flutter.macos,
              onChanged: deactivate
                  ? null
                  : (value) {
                      settings.flutter.macos = value;
                      onSave();
                    },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Windows'),
              value: settings.flutter.windows,
              onChanged: deactivate
                  ? null
                  : (value) {
                      settings.flutter.windows = value;
                      onSave();
                    },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Linux'),
              value: settings.flutter.linux,
              onChanged: deactivate
                  ? null
                  : (value) {
                      settings.flutter.linux = value;
                      onSave();
                    },
            ),
          ],
        ),
      ),
    );
  }
}
