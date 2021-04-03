import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/components/atoms/cache_size_display.dart';
import 'package:sidekick/components/atoms/screen.dart';
import 'package:sidekick/components/molecules/empty_data_set/empty_versions.dart';
import 'package:sidekick/components/molecules/version_installed_item.dart';
import 'package:sidekick/providers/installed_versions.provider.dart';
import 'package:sidekick/utils/prune_versions.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final installedList = useProvider(installedVersionsProvider);

    if (installedList == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (installedList.isEmpty) {
      return const EmptyVersions();
    }

    return Screen(
      title: 'Installed Versions',
      actions: [
        Text('${installedList.length} versions'),
        const SizedBox(width: 20),
        const CacheSizeDisplay(),
        const SizedBox(width: 20),
        Tooltip(
          message: 'Clean up unused versions.',
          child: OutlinedButton(
            child: const Text('Clean up'),
            onPressed: () async {
              await pruneVersionsDialog(context);
            },
          ),
        )
      ],
      child: Scrollbar(
        child: ListView.separated(
          itemCount: installedList.length,
          separatorBuilder: (_, __) => const Divider(height: 0),
          itemBuilder: (context, index) {
            return VersionInstalledItem(installedList[index]);
          },
        ),
      ),
    );
  }
}
