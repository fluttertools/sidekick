import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/generated/l10n.dart';

import '../../modules/common/utils/layout_size.dart';
import '../../providers/selected_detail_provider.dart';
import '../atoms/typography.dart';
import '../molecules/cache_info_tile.dart';
import '../molecules/reference_info_tile.dart';
import '../molecules/release_info_section.dart';
import '../molecules/version_install_button.dart';

/// Drawer to display selected detail
class SelectedDetailDrawer extends HookWidget {
  /// Constructors
  const SelectedDetailDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detail = useProvider(selectedDetailProvider).state;
    final selected = detail?.release;

    void onClose() {
      // Close drawer if its not large layout
      if (!LayoutSize.isLarge) {
        Navigator.pop(context);
      }
      // Clear selected detail provider
      context.read(selectedDetailProvider).state = null;
    }

    if (selected == null) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
          ),
        ),
        child: Drawer(
          elevation: 0,
          child: Container(
            color: Theme.of(context).cardColor,
            child: Center(child: Caption(S.of(context).nothingSelected)),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
        ),
      ),
      child: Drawer(
        elevation: 0,
        child: Scaffold(
          backgroundColor: Theme.of(context).cardColor,
          appBar: AppBar(
            title: Heading(selected.name),
            leading: IconButton(
              icon: const Icon(Icons.close),
              iconSize: 20,
              splashRadius: 20,
              onPressed: onClose,
            ),
            shadowColor: Colors.transparent,
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(0),
            child: VersionInstallButton(
              selected,
              warningIcon: true,
            ),
          ),
          body: CupertinoScrollbar(
            child: ListView(
              children: [
                ReferenceInfoTile(selected),
                FvmInfoTile(selected),
                ReleaseInfoSection(selected)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
