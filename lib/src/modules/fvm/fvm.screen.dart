import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18next/i18next.dart';

import '../../components/organisms/screen.dart';
import '../releases/releases.provider.dart';
import 'components/fvm_cache_size.dart';
import 'components/fvm_empty_releases.dart';
import 'components/fvm_release_list_item.dart';
import 'dialogs/cleanup_unused_dialog.dart';

class FVMScreen extends HookWidget {
  const FVMScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appReleaseState = useProvider(releasesStateProvider);
    final cachedVersions = appReleaseState.all;

    if (appReleaseState.fetching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cachedVersions.isEmpty) {
      return const EmptyVersions();
    }

    return SkScreen(
      title: I18Next.of(context).t('modules:fvm.installedVersions'),
      actions: [
        Text(
          I18Next.of(context).t(
            'modules:fvm.numberOfCachedVersions',
            variables: {
              'cachedVersions': cachedVersions.length,
            },
          ),
        ),
        const SizedBox(width: 20),
        const FvmCacheSize(),
        const SizedBox(width: 20),
        Tooltip(
          message: I18Next.of(context).t('modules:fvm.cleanUpTooltip'),
          child: OutlinedButton(
            onPressed: () async {
              await cleanupUnusedDialog(context);
            },
            child: Text(I18Next.of(context).t('modules:fvm.cleanUp')),
          ),
        )
      ],
      child: CupertinoScrollbar(
        child: ListView.separated(
          itemCount: cachedVersions.length,
          separatorBuilder: (_, __) => const Divider(height: 0),
          itemBuilder: (context, index) {
            return FvmReleaseListItem(cachedVersions[index]);
          },
        ),
      ),
    );
  }
}
