import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:sidekick/components/atoms/cache_date_display.dart';
import 'package:sidekick/components/atoms/group_tile.dart';
import 'package:sidekick/components/atoms/list_tile.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/dto/release.dto.dart';

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
          //TODO: Open in directory
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
