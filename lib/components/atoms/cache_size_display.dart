import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/providers/fvm_cache.provider.dart';

class CacheSizeDisplay extends HookWidget {
  const CacheSizeDisplay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cacheSize = useProvider(fvmCacheSizeProvider).state;

    if (cacheSize == null) {
      return const SizedBox(height: 0);
    }

    return Container(
      child: Caption('Total size: $cacheSize'),
    );
  }
}
