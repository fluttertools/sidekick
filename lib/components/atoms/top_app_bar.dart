import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/components/molecules/update_available_button.dart';
import 'package:sidekick/constants.dart';
import 'package:sidekick/providers/navigation_provider.dart';
import 'package:sidekick/screens/settings_screen.dart';
import 'package:sidekick/theme.dart';

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
      title: const Caption(kAppTitle),
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
