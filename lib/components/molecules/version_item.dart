import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/components/atoms/list_tile.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/components/molecules/version_install_button.dart';
import 'package:sidekick/dto/version.dto.dart';
import 'package:sidekick/providers/selected_info_provider.dart';

class VersionItem extends StatelessWidget {
  final VersionDto version;

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
          context.read(selectedInfoProvider).selectVersion(version);
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
