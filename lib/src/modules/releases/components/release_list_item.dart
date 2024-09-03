import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../components/atoms/typography.dart';
import '../../../components/molecules/list_tile.dart';
import '../../../components/molecules/version_install_button.dart';
import '../../../modules/common/dto/release.dto.dart';
import '../../selected_detail/selected_detail.provider.dart';

/// Release list item
class ReleaseListItem extends ConsumerWidget {
  /// Constructor
  const ReleaseListItem(
    this.release, {
    super.key,
  });

  /// Release in item
  final ReleaseDto release;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: SkListTile(
        title: Subheading(release.name),
        onTap: () {
          ref.read(selectedDetailProvider.notifier).state = SelectedDetail(
            release: release,
          );
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 10),
            VersionInstallButton(release),
          ],
        ),
      ),
    );
  }
}
