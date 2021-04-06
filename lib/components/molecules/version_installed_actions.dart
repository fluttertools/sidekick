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
}

class VersionInstalledActions extends StatelessWidget {
  final ReleaseDto version;
  const VersionInstalledActions(this.version, {Key key}) : super(key: key);

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
      },
      child: const Icon(MdiIcons.dotsVertical),
      itemBuilder: (context) {
        return <PopupMenuEntry<InstalledActions>>[
          const PopupMenuItem(
            value: InstalledActions.global,
            child: Caption('Set Global'),
          ),
          const PopupMenuItem(
            value: InstalledActions.detail,
            child: Caption('Details'),
          ),
          const PopupMenuItem(
            value: InstalledActions.remove,
            child: Caption('Remove'),
          ),
        ];
      },
    );
  }
}
