import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/components/molecules/delete_dialog.dart';
import 'package:sidekick/dto/release.dto.dart';
import 'package:sidekick/providers/fvm_queue.provider.dart';
import 'package:sidekick/providers/selected_info_provider.dart';

import '../../providers/fvm_queue.provider.dart';
import '../atoms/typography.dart';

enum InstalledActions {
  remove,
  detail,
  global,
  upgrade,
}

class CacheVersionActions extends StatelessWidget {
  final ReleaseDto version;
  const CacheVersionActions(this.version, {Key key}) : super(key: key);

  Widget renderMenuButton({IconData icon, String label}) {
    return Row(
      children: [
        Icon(
          icon,
          // size: 20,
        ),
        const SizedBox(width: 10),
        Subheading(label),
      ],
    );
  }

  List<PopupMenuEntry<InstalledActions>> renderMenuOptions() {
    final menus = <PopupMenuEntry<InstalledActions>>[
      PopupMenuItem(
        value: InstalledActions.global,
        child: renderMenuButton(
          label: 'Set as global',
          icon: MdiIcons.earth,
        ),
      ),
      PopupMenuItem(
        value: InstalledActions.detail,
        child: renderMenuButton(
          label: 'Details',
          icon: MdiIcons.information,
        ),
      ),
      PopupMenuItem(
        value: InstalledActions.remove,
        child: renderMenuButton(
          label: 'Remove',
          icon: MdiIcons.delete,
        ),
      ),
    ];

    // Only display upgrade if option is channel
    if (version.isChannel) {
      menus.insert(
        0,
        PopupMenuItem(
          value: InstalledActions.upgrade,
          child: renderMenuButton(
            label: 'Upgrade',
            icon: MdiIcons.update,
          ),
        ),
      );
    }

    return menus;
  }

  @override
  Widget build(BuildContext context) {
    if (version == null) {
      return const SizedBox(height: 0);
    }
    return PopupMenuButton<InstalledActions>(
      onSelected: (result) {
        if (result == InstalledActions.remove) {
          showDeleteDialog(context, item: version, onDelete: () {
            context.read(fvmQueueProvider).remove(version);
          });
        }

        if (result == InstalledActions.detail) {
          context.read(selectedInfoProvider).selectVersion(version);
        }

        if (result == InstalledActions.global) {
          context.read(fvmQueueProvider).setGloabl(version);
        }

        if (result == InstalledActions.upgrade) {
          context.read(fvmQueueProvider).upgrade(version);
        }
      },
      child: const Icon(MdiIcons.dotsVertical),
      itemBuilder: (context) {
        return renderMenuOptions();
      },
    );
  }
}
