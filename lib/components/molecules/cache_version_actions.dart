import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../dto/release.dto.dart';
import '../../modules/fvm/fvm_queue.provider.dart';
import '../../providers/selected_info_provider.dart';
import '../atoms/typography.dart';
import 'delete_dialog.dart';

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
          size: 15,
        ),
        const SizedBox(width: 10),
        Caption(label),
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
            context.read(fvmQueueProvider.notifier).remove(version);
          });
        }

        if (result == InstalledActions.detail) {
          context.read(selectedInfoProvider.notifier).selectVersion(version);
        }

        if (result == InstalledActions.global) {
          context.read(fvmQueueProvider.notifier).setGloabl(version);
        }

        if (result == InstalledActions.upgrade) {
          context.read(fvmQueueProvider.notifier).upgrade(version);
        }
      },
      child: const Icon(MdiIcons.dotsVertical),
      itemBuilder: (context) {
        return renderMenuOptions();
      },
    );
  }
}
