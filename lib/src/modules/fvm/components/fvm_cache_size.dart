import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';

import '../../../components/atoms/typography.dart';
import '../../../modules/common/utils/dir_stat.dart';
import '../fvm.provider.dart';

/// Fvm cache size
class FvmCacheSize extends HookConsumerWidget {
  /// Constructor
  const FvmCacheSize({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheSize = ref.watch(cacheSizeProvider);
    final unusedSize = useState(DirectorySizeInfo());
    ref
        .watch(unusedReleaseSizeProvider)
        .whenData((value) => unusedSize.value = value);

    if (cacheSize.totalSize == 0) {
      return Container();
    }

    final unusedPercentage = unusedSize.value.totalSize / cacheSize.totalSize;

    return Row(
      children: [
        SizedBox(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  value: 1 - unusedPercentage,
                  minHeight: 5,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Caption(context.i18n('modules:fvm.components.inUse')),
                  Caption(cacheSize.friendlySize),
                  Caption(context.i18n('modules:fvm.components.unused')),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
