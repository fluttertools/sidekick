import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';

import '../../../components/atoms/typography.dart';
import '../../../components/molecules/list_tile.dart';
import '../../../modules/common/dto/release.dto.dart';
import '../../selected_detail/selected_detail.provider.dart';
import '../dialogs/fvm_global_dialog.dart';
import 'fvm_release_actions.dart';
import 'fvm_release_status.dart';

/// FVM release list item
class FvmReleaseListItem extends ConsumerWidget {
  /// Constructor
  const FvmReleaseListItem(
    this.release, {
    Key? key,
  }) : super(key: key);

  /// Release
  final ReleaseDto release;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SkListTile(
      leading: release.isChannel
          ? const Icon(MdiIcons.alphaCCircle)
          : const Icon(MdiIcons.alphaRCircle),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Subheading(release.name),
          const SizedBox(width: 20),
          release.isGlobal
              ? ActionChip(
                  label: Caption(context.i18n('modules:fvm.components.global')),
                  avatar: const Icon(MdiIcons.information, size: 15),
                  onPressed: () {
                    showGlobalInfoDialog(context);
                  },
                )
              : Container(),
          const Spacer(),
          FvmReleaseStatus(release),
        ],
      ),
      trailing: FvmReleaseActions(release),
      onTap: () {
        ref.read(selectedDetailProvider.notifier).state = SelectedDetail(
          release: release,
        );
      },
    );
  }
}
