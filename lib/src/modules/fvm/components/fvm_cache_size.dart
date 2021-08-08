import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18next/i18next.dart';

import '../../../components/atoms/typography.dart';
import '../../../modules/common/utils/dir_stat.dart';
import '../fvm.provider.dart';

/// Fvm cache size
class FvmCacheSize extends HookWidget {
  /// Constructor
  const FvmCacheSize({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cacheSize = useProvider(cacheSizeProvider).state;
    final unusedSize = useState(DirectorySizeInfo());
    useProvider(unusedReleaseSizeProvider)
        .whenData((value) => unusedSize.value = value);

    if (cacheSize.totalSize == 0) {
      return Container();
    }

    final unusedPercentage = unusedSize.value.totalSize / cacheSize.totalSize;

    if (cacheSize == null) {
      return const SizedBox(height: 0);
    }

    return Container(
      child: Row(
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
                    Caption(
                        I18Next.of(context).t('modules:fvm.components.inUse')),
                    Caption(cacheSize.friendlySize),
                    Caption(
                        I18Next.of(context).t('modules:fvm.components.unused')),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
