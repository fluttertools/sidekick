import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';

import '../../components/organisms/screen.dart';
import '../releases/releases.provider.dart';
import 'components/fvm_cache_size.dart';
import 'components/fvm_empty_releases.dart';
import 'components/fvm_release_list_item.dart';
import 'dialogs/cleanup_unused_dialog.dart';

class FVMScreen extends ConsumerWidget {
  const FVMScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cachedVersions = ref.watch(releasesStateProvider);
    final sdkScrollController = ScrollController();

    if (cachedVersions.fetching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cachedVersions.all.isEmpty) {
      return const EmptyVersions();
    }

    return SkScreen(
      title: context.i18n('modules:fvm.installedVersions'),
      actions: [
        Text(
          context.i18n(
            'modules:fvm.numberOfCachedVersions',
            variables: {
              'cachedVersions': cachedVersions.all.length,
            },
          ),
        ),
        const SizedBox(width: 20),
        const FvmCacheSize(),
        const SizedBox(width: 20),
        Consumer(
          builder: (context, ref, _) => Tooltip(
            message: context.i18n('modules:fvm.cleanUpTooltip'),
            child: OutlinedButton(
              onPressed: () async {
                await cleanupUnusedDialog(context, ref);
              },
              child: Text(context.i18n('modules:fvm.cleanUp')),
            ),
          ),
        ),
      ],
      child: CupertinoScrollbar(
        controller: sdkScrollController,
        child: ListView.separated(
          controller: sdkScrollController,
          itemCount: cachedVersions.all.length,
          separatorBuilder: (_, __) => const Divider(height: 0),
          itemBuilder: (context, index) {
            return FvmReleaseListItem(
              cachedVersions.all[index],
            );
          },
        ),
      ),
    );
  }
}
