import 'package:flutter/material.dart';

import '../../../components/atoms/copy_button.dart';
import '../../../components/atoms/group_tile.dart';
import '../../../components/atoms/typography.dart';
import '../../../components/molecules/list_tile.dart';
import '../../common/dto/release.dto.dart';
import '../../common/utils/open_link.dart';

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
      title: Text(I18Next.of(context).t.advanced),
      children: [
        SkListTile(
          title: Text(I18Next.of(context).t.downloadZip),
          subtitle:
              Caption(I18Next.of(context).t.zipFileWithAllReleaseDependencies),
          trailing: IconButton(
            icon: const Icon(Icons.cloud_download),
            onPressed: () async {
              await openLink(release.release.archiveUrl);
            },
          ),
        ),
        const Divider(),
        SkListTile(
          title: Text(I18Next.of(context).t.hash),
          subtitle: Caption(release.release.hash),
          trailing: CopyButton(release.release.hash),
        ),
        const Divider(),
        SkListTile(
          title: Text(I18Next.of(context).t.sha256),
          subtitle: Caption(release.release.sha256),
          trailing: CopyButton(release.release.sha256),
        ),
      ],
    );
  }
}
