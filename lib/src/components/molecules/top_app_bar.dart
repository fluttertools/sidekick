import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/src/components/atoms/typography.dart';
import 'package:sidekick/src/modules/common/constants.dart';
import 'package:sidekick/src/modules/navigation/navigation.provider.dart';
import 'package:sidekick/src/modules/settings/settings.screen.dart';
import 'package:sidekick/src/modules/updater/components/update_button.dart';
import 'package:sidekick/src/theme.dart';
import 'package:sidekick/src/version.dart';
import 'package:sidekick/src/window_border.dart';

/// Sidekick top app bar
class SkAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Constructor
  const SkAppBar({key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(45);

  @override
  Widget build(BuildContext context) {
    // Opens setting modal
    void openSettingsScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SettingsScreen(),
        ),
      );
    }

    /// Opens up search modal
    void openSearchModal() {
      context
          .read(navigationProvider.notifier)
          .goTo(NavigationRoutes.searchScreen);
    }

    Widget renderTitle() {
      if (!Platform.isMacOS) {
        return Row(
          children: const [
            SizedBox(width: 10),
            Caption(kAppTitle),
          ],
        );
      }
      return const Caption(kAppTitle);
    }

    return AppBar(
      backgroundColor: platformBackgroundColor(context),
      title: renderTitle(),
      centerTitle: Platform.isWindows ? false : true,
      titleSpacing: 0,
      foregroundColor: platformBackgroundColor(context),
      scrolledUnderElevation: 0,
      leading: Platform.isMacOS ? const WindowButtons() : null,
      actions: [
        const SkUpdateButton(),
        const SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Caption(packageVersion),
          ],
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.search),
          iconSize: 20,
          color: Theme.of(context).colorScheme.onSurface,
          splashRadius: 15,
          onPressed: openSearchModal,
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          iconSize: 20,
          color: Theme.of(context).colorScheme.onSurface,
          splashRadius: 15,
          onPressed: openSettingsScreen,
        ),
        const SizedBox(width: 10),
        if (!Platform.isMacOS) const WindowButtons(),
      ],
      bottom: !Platform.isWindows
          ? const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(
                height: 0,
                thickness: 0.5,
              ),
            )
          : null,
      automaticallyImplyLeading: false,
      // shadowColor: Colors.transparent,
      // backgroundColor: Colors.transparent,
      flexibleSpace: MoveWindow(),
    );
  }
}
