import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../components/atoms/typography.dart';
import '../../../modules/common/dto/release.dto.dart';
import '../../selected_detail/selected_detail.provider.dart';
import '../dialogs/fvm_delete_dialog.dart';
import '../fvm_queue.provider.dart';

/// Possible actions for installed release
enum FvmReleaseActionOptions {
  /// Remove release
  remove,

  /// View details
  detail,

  /// Set as global
  global,

  /// Upgrade
  upgrade,
}

/// Displays actions for a cached release
class FvmReleaseActions extends StatelessWidget {
  /// Constructor
  const FvmReleaseActions(
    this.release, {
    Key key,
  }) : super(key: key);

  /// Release
  final ReleaseDto release;

  /// Render menu button
  Widget renderMenuButton({
    IconData icon,
    String label,
  }) {
    return Row(
      children: [
        Icon(icon, size: 15),
        const SizedBox(width: 10),
        Caption(label),
      ],
    );
  }

  /// Renders menu options
  List<PopupMenuEntry<FvmReleaseActionOptions>> renderMenuOptions() {
    final menus = <PopupMenuEntry<FvmReleaseActionOptions>>[
      PopupMenuItem(
        value: FvmReleaseActionOptions.global,
        child: renderMenuButton(
          label: S.current.setAsGlobal,
          icon: MdiIcons.earth,
        ),
      ),
      PopupMenuItem(
        value: FvmReleaseActionOptions.detail,
        child: renderMenuButton(
          label: S.current.details,
          icon: MdiIcons.information,
        ),
      ),
      PopupMenuItem(
        value: FvmReleaseActionOptions.remove,
        child: renderMenuButton(
          label: S.current.remove,
          icon: MdiIcons.delete,
        ),
      ),
    ];

    // Only display upgrade if option is channel
    if (release.isChannel) {
      menus.insert(
        0,
        PopupMenuItem(
          value: FvmReleaseActionOptions.upgrade,
          child: renderMenuButton(
            label: S.current.upgrade,
            icon: MdiIcons.update,
          ),
        ),
      );
    }

    return menus;
  }

  @override
  Widget build(BuildContext context) {
    /// Return empty if there is no release
    if (release == null) {
      return const SizedBox(height: 0);
    }
    return PopupMenuButton<FvmReleaseActionOptions>(
      onSelected: (result) {
        if (result == FvmReleaseActionOptions.remove) {
          showDeleteDialog(context, item: release, onDelete: () {
            context.read(fvmQueueProvider.notifier).remove(release);
          });
        }

        if (result == FvmReleaseActionOptions.detail) {
          context.read(selectedDetailProvider).state = SelectedDetail(
            release: release,
          );
        }

        if (result == FvmReleaseActionOptions.global) {
          context.read(fvmQueueProvider.notifier).setGlobal(release);
        }

        if (result == FvmReleaseActionOptions.upgrade) {
          context.read(fvmQueueProvider.notifier).upgrade(release);
        }
      },
      itemBuilder: (context) {
        return renderMenuOptions();
      },
      child: const Icon(MdiIcons.dotsVertical),
    );
  }
}
