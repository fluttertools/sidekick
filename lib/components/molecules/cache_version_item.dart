import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/components/atoms/list_tile.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/components/molecules/version_install_status.dart';
import 'package:sidekick/components/molecules/version_installed_actions.dart';
import 'package:sidekick/components/organisms/global_info_dialog.dart';
import 'package:sidekick/dto/release.dto.dart';
import 'package:sidekick/providers/selected_info_provider.dart';

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
              ? MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      showGlobalInfoDialog(context);
                    },
                    child: const Chip(
                      label: Caption('Global'),
                      avatar: Icon(MdiIcons.information, size: 20),
                    ),
                  ),
                )
              : Container(),
          const Spacer(),
          VersionInstalledStatus(version),
        ],
      ),
      trailing: VersionInstalledActions(version),
      onTap: () {
        context.read(selectedInfoProvider).selectVersion(version);
      },
    );
  }
}
