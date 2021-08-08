import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../components/atoms/typography.dart';
import '../../releases/releases.provider.dart';
import '../settings.dto.dart';

/// Flutter settings section
class SettingsSectionFlutter extends HookWidget {
  /// Constructor
  const SettingsSectionFlutter(
    this.settings,
    this.onSave, {
    Key key,
  }) : super(key: key);

  /// Settings
  final AllSettings settings;

  /// On save handler
  final Function() onSave;
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
                        child: Text(
                          I18Next.of(context).t.flutterSDKGlobalDescription,
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
            SwitchListTile(
              title: Text(I18Next.of(context).t.analyticsCrashReporting),
              subtitle: Text(
                I18Next.of(context).t.analyticsCrashReportSubtitle,
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
            Subheading(I18Next.of(context).t.platforms),
            const SizedBox(height: 20),
            SwitchListTile(
              title: Text(I18Next.of(context).t.web),
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
