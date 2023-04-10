import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/src/window_border.dart';

import '../../modules/common/utils/helpers.dart';
import '../../modules/common/utils/notify.dart';
import 'scenes/flutter_settings.scene.dart';
import 'scenes/fvm_settings.scene.dart';
import 'scenes/general_settings.scene.dart';
import 'settings.provider.dart';

/// TODO: Unify the nav sections information
/// Nav sections
enum NavSection {
  /// General
  general,

  /// FVM
  fvm,

  /// Flutter
  flutter,
}

const _sectionIcons = [
  MdiIcons.tune,
  MdiIcons.layers,
  MdiIcons.console,
];

/// Settings screen
class SettingsScreen extends HookConsumerWidget {
  /// Constructor
  const SettingsScreen({
    this.section = NavSection.general,
    key,
  }) : super(key: key);

  /// Current nav section
  final NavSection section;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(settingsProvider.notifier);
    final settings = ref.watch(settingsProvider);

    final currentSection = useState(section.index);

    final controller = usePageController(initialPage: section.index);

    final _sections = [
      context.i18n('modules:settings.scenes.general'),
      'FVM',
      'Flutter'
    ];

    void changeSection(int idx) {
      currentSection.value = idx;
      controller.jumpToPage(idx);
    }

    Future<void> handleSave() async {
      final savedMessage =
          context.i18n('modules:settings.settingsHaveBeenSaved');
      final errorMessage =
          context.i18n('modules:settings.couldNotSaveSettings');
      try {
        await provider.save(settings);
        notify(savedMessage);
      } on Exception catch (e) {
        notifyError(errorMessage);
        notifyError(e.toString());
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          if (!Platform.isMacOS) const SizedBox(width: 20),
          IconButton(
            icon: const BackButtonIcon(),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            splashRadius: 20,
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
          if (!Platform.isMacOS) Expanded(child: MoveWindow()),
          const SizedBox(width: 10),
          if (!Platform.isMacOS) const WindowButtons(),
        ],
      ),
      body: Row(
        children: [
          const SizedBox(width: 50),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView(
                controller: ScrollController(),
                children: _sections.mapIndexed(
                  (section, idx) {
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50000),
                      ),
                      leading: Icon(
                        _sectionIcons[idx],
                        size: 20,
                      ),
                      title: Text(
                        section,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      selectedTileColor: Theme.of(context).hoverColor,
                      selected: currentSection.value == idx,
                      onTap: () => changeSection(idx),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          const SizedBox(width: 60),
          Expanded(
            flex: 3,
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              controller: controller,
              children: [
                SettingsSectionGeneral(settings, handleSave),
                FvmSettingsScene(settings, handleSave),
                SettingsSectionFlutter(settings, handleSave),
              ],
            ),
          ),
          const SizedBox(width: 50),
        ],
      ),
    );
  }
}
