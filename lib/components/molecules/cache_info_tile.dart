import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import '../../dto/release.dto.dart';
import '../atoms/cache_date_display.dart';
import '../atoms/group_tile.dart';
import '../atoms/list_tile.dart';
import '../atoms/typography.dart';

class CacheInfoTile extends StatelessWidget {
  final ReleaseDto version;
  const CacheInfoTile(this.version, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!version.isCached) {
      return const SizedBox(height: 0);
    }
    return FvmGroupListTile(
      title: const Text('Local Cache Information'),
      children: [
        FvmListTile(
          title: const Text('Created Date'),
          trailing: CacheDateDisplay(version),
        ),
        const Divider(height: 0),
        FvmListTile(
          title: const Text('Cache Location'),
          subtitle: Caption(version.cache.dir.path),
          trailing: IconButton(
            icon: const Icon(
              Icons.open_in_new,
              size: 20,
            ),
            onPressed: () async {
              await OpenFile.open(version.cache.dir.path);
            },
          ),
        ),
      ],
    );
  }
}
