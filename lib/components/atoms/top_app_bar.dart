import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/providers/navigation_provider.dart';
import 'package:sidekick/screens/settings_screen.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(45);

  @override
  Widget build(BuildContext context) {
    // Opens setting modal
    void openSettingsModal() {
      showMaterialModalBottomSheet(
        enableDrag: false,
        context: context,
        builder: (context) => const SettingsScreen(),
      );
    }

    /// Opens up search modal
    void openSearchModal() {
      context.read(navigationProvider).goTo(NavigationRoutes.searchScreen);
    }

    return AppBar(
      title: const Subheading('Sidekick'),
      centerTitle: true,
      actions: [
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
          onPressed: openSettingsModal,
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
