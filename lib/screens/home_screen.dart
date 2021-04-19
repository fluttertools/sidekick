import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/components/atoms/cache_size_display.dart';
import 'package:sidekick/components/atoms/screen.dart';
import 'package:sidekick/components/molecules/cache_version_item.dart';
import 'package:sidekick/components/molecules/empty_data_set/empty_versions.dart';
import 'package:sidekick/components/organisms/cleanup_unused_dialog.dart';
import 'package:sidekick/providers/flutter_releases.provider.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cachedVersions = useProvider(releasesStateProvider).allCached;

    if (cachedVersions == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cachedVersions.isEmpty) {
      return const EmptyVersions();
    }

    return Screen(
      title: 'Installed Versions',
      actions: [
        Text('${cachedVersions.length} versions'),
        const SizedBox(width: 20),
        const CacheSizeDisplay(),
        const SizedBox(width: 20),
        Tooltip(
          message: 'Clean up unused versions.',
          child: OutlinedButton(
            child: const Text('Clean up'),
            onPressed: () async {
              await cleanupUnusedDialog(context);
            },
          ),
        )
      ],
      child: CupertinoScrollbar(
        child: ListView.separated(
          itemCount: cachedVersions.length,
          separatorBuilder: (_, __) => const Divider(height: 0),
          itemBuilder: (context, index) {
            return CacheVersionItem(cachedVersions[index]);
          },
        ),
      ),
    );
  }
}
