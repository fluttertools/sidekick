import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../dto/release.dto.dart';
import '../../providers/selected_info_provider.dart';
import '../atoms/list_tile.dart';
import '../atoms/typography.dart';
import 'version_install_button.dart';

class VersionItem extends StatelessWidget {
  final ReleaseDto version;

  const VersionItem(this.version, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: FvmListTile(
        title: Subheading(version.name),
        onTap: () {
          context.read(selectedInfoProvider.notifier).selectVersion(version);
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 10),
            VersionInstallButton(version),
          ],
        ),
      ),
    );
  }
}
