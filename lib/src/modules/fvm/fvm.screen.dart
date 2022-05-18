import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';

import '../../components/organisms/screen.dart';
import '../releases/releases.provider.dart';
import 'components/fvm_cache_size.dart';
import 'components/fvm_empty_releases.dart';
import 'components/fvm_release_list_item.dart';
import 'dialogs/cleanup_unused_dialog.dart';

class FVMScreen extends HookWidget {
  const FVMScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cachedVersions = useProvider(releasesStateProvider);

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
        Tooltip(
          message: context.i18n('modules:fvm.cleanUpTooltip'),
          child: OutlinedButton(
            onPressed: () async {
              await cleanupUnusedDialog(context);
            },
            child: Text(context.i18n('modules:fvm.cleanUp')),
          ),
        )
      ],
      child: ListView.separated(
        itemCount: cachedVersions.all.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, index) {
          return FvmReleaseListItem(
            cachedVersions.all[index],
          );
        },
      ),
    );
  }
}
