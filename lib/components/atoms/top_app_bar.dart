import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants.dart';
import '../../modules/settings/settings.screen.dart';
import '../../providers/navigation_provider.dart';
import '../../theme.dart';
import '../molecules/update_available_button.dart';
import 'typography.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({key}) : super(key: key);

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

    return AppBar(
      backgroundColor: platformBackgroundColor(context),
      title: Platform.isMacOS
          ? const Caption(kAppTitle)
          : const SizedBox(height: 0, width: 0),
      centerTitle: true,
      actions: [
        const UpdateAvailableButton(),
        IconButton(
          icon: const Icon(Icons.search),
          iconSize: 20,
          splashRadius: 15,
          onPressed: openSearchModal,
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          iconSize: 20,
          splashRadius: 15,
          onPressed: openSettingsScreen,
        ),
        const SizedBox(width: 10),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(
          height: 0,
          thickness: 0.5,
        ),
      ),
      automaticallyImplyLeading: false,
      // shadowColor: Colors.transparent,
      // backgroundColor: Colors.transparent,
      // flexibleSpace: const BlurBackground(),
    );
  }
}
