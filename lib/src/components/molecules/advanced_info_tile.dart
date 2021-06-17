import 'package:flutter/material.dart';
import 'package:sidekick/generated/l10n.dart';

import '../../dto/release.dto.dart';
import '../../modules/common/atoms/copy_button.dart';
import '../../modules/common/atoms/group_tile.dart';
import '../../modules/common/molecules/list_tile.dart';
import '../../modules/common/utils/open_link.dart';
import '../atoms/typography.dart';

/// Advanced info tile
class AdvancedInfoTile extends StatelessWidget {
  /// Constructor
  const AdvancedInfoTile(
    this.release, {
    Key key,
  }) : super(key: key);

  /// Release
  final ReleaseDto release;

  @override
  Widget build(BuildContext context) {
    if (release.release == null) {
      return const SizedBox(height: 0);
    }

    return SkGroupTile(
      title: Text(S.of(context).advanced),
      children: [
        SkListTile(
          title: Text(S.of(context).downloadZip),
          subtitle: Caption(S.of(context).zipFileWithAllReleaseDependencies),
          trailing: IconButton(
            icon: const Icon(Icons.cloud_download),
            onPressed: () async {
              await openLink(release.release.archiveUrl);
            },
          ),
        ),
        const Divider(),
        SkListTile(
          title: Text(S.of(context).hash),
          subtitle: Caption(release.release.hash),
          trailing: CopyButton(release.release.hash),
        ),
        const Divider(),
        SkListTile(
          title: Text(S.of(context).sha256),
          subtitle: Caption(release.release.sha256),
          trailing: CopyButton(release.release.sha256),
        ),
      ],
    );
  }
}
