import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sidekick/components/atoms/screen.dart';
import 'package:sidekick/providers/flutter_projects_provider.dart';
import 'package:sidekick/providers/settings.provider.dart';
import 'package:sidekick/utils/notify.dart';

class SettingsScreen extends HookWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = useProvider(settingsProvider);
    final settings = useProvider(settingsProvider.state);
    final projects = useProvider(projectsProvider);
    final prevProjectsDir = usePrevious(settings.app.firstProjectDir);

    Future<void> handleSave() async {
      try {
        await provider.save(settings);
        if (prevProjectsDir != settings.app.firstProjectDir) {
          await projects.scan();
        }
        notify('Settings have been saved');
      } on Exception {
        notifyError('Could not refresh projects');
        settings.app.firstProjectDir = prevProjectsDir;
        await provider.save(settings);
      }
    }

    return FvmScreen(
      title: 'Settings',
      child: SettingsList(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        sections: [
          SettingsSection(
            title: "FVM Settings",
            tiles: [
              SettingsTile(
                title: 'Flutter Projects',
                subtitle: settings.app.firstProjectDir,
                leading: const Icon(MdiIcons.folderHome),
                subtitleTextStyle: Theme.of(context).textTheme.caption,
                onTap: () async {
                  final fileResult = await showOpenPanel(
                    allowedFileTypes: [],
                    canSelectDirectories: true,
                  );

                  // Save if a path is selected
                  if (fileResult.paths.isNotEmpty) {
                    settings.app.firstProjectDir = fileResult.paths.single;
                  }

                  await handleSave();
                },
              ),
              SettingsTile.switchTile(
                title: 'Disable tracking',
                subtitle: """
This will disable Google's crash reporting and analytics, when installing a new version.""",
                leading: const Icon(MdiIcons.bug),
                switchActiveColor: Theme.of(context).accentColor,
                switchValue: settings.fvm.noAnalytics ?? false,
                subtitleTextStyle: Theme.of(context).textTheme.caption,
                onToggle: (value) async {
                  settings.fvm.noAnalytics = value;
                  await handleSave();
                },
              ),
              SettingsTile.switchTile(
                title: 'Skip setup Flutter on install',
                subtitle:
                    """This will only clone Flutter and not install dependencies after a new version is installed.""",
                leading: const Icon(MdiIcons.cogSync),
                switchActiveColor: Theme.of(context).accentColor,
                subtitleTextStyle: Theme.of(context).textTheme.caption,
                switchValue: settings.fvm.skipSetup ?? false,
                onToggle: (value) async {
                  settings.fvm.skipSetup = value;
                  await handleSave();
                },
              ),
            ],
          ),
          SettingsSection(
            title: "App Settings",
            tiles: [
              SettingsTile(
                title: "Theme",
                subtitle: "Which theme to start the app with.",
                leading: const Icon(Icons.color_lens_rounded),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor.withOpacity(0.02),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  constraints:
                      const BoxConstraints(minWidth: 110, maxWidth: 165),
                  child: DropdownButton(
                    items: const [
                      DropdownMenuItem(
                        child: Text("System"),
                        value: "system",
                      ),
                      DropdownMenuItem(
                        child: Text("Light"),
                        value: "light",
                      ),
                      DropdownMenuItem(
                        child: Text("Dark"),
                        value: "dark",
                      ),
                    ],
                    onChanged: (brightness) {
                      settings.app.themeMode = brightness;
                      handleSave();
                    },
                    value: settings.app.themeMode,
                    underline: Container(),
                  ),
                ),
              ),
              /*SettingsTile(
                title: "Github Token",
                leading: const Icon(MdiIcons.github),
                subtitle: "The token will be used to fetch"
                    " data for your installed packages",
                trailing: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  constraints:
                      const BoxConstraints(maxWidth: 390, minWidth: 50),
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box("settings").listenable(),
                    builder: (context, value, child) => TextField(
                      expands: false,
                      maxLength: 40,
                      autocorrect: false,
                      onChanged: (text) => value.put("gh_token", text),
                      decoration: InputDecoration(
                        hintText: value.get("gh_token"),
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),*/
              /*SettingsTile(
                title: "Open projects with",
                subtitle: "Select what program to open pages as."
                    " Currently only VS Code is available.",
                leading: const Icon(Icons.code_rounded),
                trailing: ValueListenableBuilder(
                  builder: (context, value, child) => Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor.withOpacity(0.02),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    constraints:
                        const BoxConstraints(minWidth: 220, maxWidth: 250),
                    child: DropdownButton(
                      items: [
                        ...ideMap.values.map((element) {
                          return DropdownMenuItem(
                            child: Row(
                              children: [
                                Icon(element.icon),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(element.name),
                              ],
                            ),
                            value: element.identifier,
                          );
                        }).toList()
                      ],
                      onChanged: (val) {
                        value.put("open_ide", val);
                      },
                      value: value.get("open_ide", defaultValue: "vsCode"),
                      underline: Container(),
                    ),
                  ),
                  valueListenable: Hive.box('settings').listenable(),
                ),
              ),*/
              const SettingsTile(
                title: "App version",
                subtitle: "App version and updates",
                leading: Icon(Icons.info_outline_rounded),
                trailing: AppVersionInfo(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
