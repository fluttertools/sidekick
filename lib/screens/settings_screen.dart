import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sidekick/components/atoms/screen.dart';
import 'package:sidekick/providers/settings.provider.dart';
import 'package:sidekick/utils/get_theme_mode.dart';
import 'package:sidekick/utils/notify.dart';
import 'package:sidekick/version.dart';

class SettingsScreen extends HookWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = useProvider(settingsProvider);
    final settings = useProvider(settingsProvider.state);

    Future<void> handleSave() async {
      try {
        await provider.save(settings);
        notify('Settings have been saved');
      } on Exception {
        notifyError('Could not save settings');
      }
    }

    Future<void> handleChooseDirectory() async {
      showMaterialModalBottomSheet(
        enableDrag: false,
        context: context,
        builder: (context) => const SettingsScreen(),
      );
      return;
      final fileResult = await showOpenPanel(
        allowedFileTypes: [],
        canSelectDirectories: true,
      );

      // Save if a path is selected
      if (fileResult.paths.isNotEmpty) {
        settings.sidekick.firstProjectDir = fileResult.paths.single;
      }

      await handleSave();
    }

    if (settings.sidekick == null) {
      return Container();
    }

    return FvmScreen(
      title: 'Settings',
      actions: [
        IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
      child: SettingsList(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        sections: [
          SettingsSection(
            tiles: [
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
                  handleSave();
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Projects',
            tiles: [
              SettingsTile(
                title: 'Flutter Projects',
                subtitle: settings.sidekick.firstProjectDir,
                leading: const Icon(MdiIcons.folderHome),
                subtitleTextStyle: Theme.of(context).textTheme.caption,
                trailing: ElevatedButton.icon(
                  label: const Text('Choose'),
                  icon: const Icon(MdiIcons.chevronDown),
                  onPressed: handleChooseDirectory,
                ),
              ),
            ],
          ),
          SettingsSection(
            title: "FVM",
            tiles: [
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
                  handleSave();
                },
              ),
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
                  handleSave();
                },
              ),
            ],
          ),
          SettingsSection(
            title: "General",
            tiles: [
              // SettingsTile.switchTile(
              //   title: 'Dark mode',
              //   onToggle: (toggle) {},
              //   switchValue: true,
              // ),
              SettingsTile(
                title: "Theme",
                leading: const Icon(Icons.color_lens_rounded),
                trailing: DropdownButton(
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
                  onChanged: (themeMode) {
                    settings.sidekick.themeMode = themeMode;
                    handleSave();
                  },
                ),
              ),
              const SettingsTile(
                title: "App version",
                leading: Icon(Icons.info_outline_rounded),
                trailing: Text(appVersion),
              ),
            ],
          ),
          SettingsSection(
            title: "Flutter",
            tiles: [
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
                  handleSave();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
