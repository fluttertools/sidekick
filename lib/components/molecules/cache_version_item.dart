import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../dto/release.dto.dart';
import '../../providers/selected_info_provider.dart';
import '../atoms/list_tile.dart';
import '../atoms/typography.dart';
import '../organisms/global_info_dialog.dart';
import 'cache_version_actions.dart';
import 'cache_version_status.dart';

class CacheVersionItem extends StatelessWidget {
  final ReleaseDto version;

  const CacheVersionItem(
    this.version, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FvmListTile(
      leading: version.isChannel
          ? const Icon(MdiIcons.alphaCCircle)
          : const Icon(MdiIcons.alphaRCircle),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Subheading(version.name),
          const SizedBox(width: 20),
          version.isGlobal
              ? ActionChip(
                  label: const Caption('Global'),
                  avatar: const Icon(MdiIcons.information, size: 20),
                  onPressed: () {
                    showGlobalInfoDialog(context);
                  },
                )
              : Container(),
          const Spacer(),
          CacheVersionStatus(version),
        ],
      ),
      trailing: CacheVersionActions(version),
      onTap: () {
        context.read(selectedInfoProvider.notifier).selectVersion(version);
      },
    );
  }
}
