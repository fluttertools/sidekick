import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/providers/flutter_releases.provider.dart';

enum Filter {
  beta,
  stable,
  dev,
  all,
}

extension FilterExtension on Filter {
  /// Name of the channel
  String get name {
    final self = this;
    return self.toString().split('.').last;
  }
}

/// Returns a [Channel] from [name]
Filter filterFromName(String name) {
  switch (name) {
    case 'stable':
      return Filter.stable;
    case 'dev':
      return Filter.dev;
    case 'beta':
      return Filter.beta;
    case 'all':
      return Filter.all;
    default:
      return null;
  }
}

final filterProvider = StateProvider<Filter>((_) => Filter.all);

// ignore: top_level_function_literal_block
final filterableVersionsProvider = Provider((ref) {
  final filter = ref.watch(filterProvider).state;
  final releases = ref.watch(releasesStateProvider);

  if (filter == Filter.all) {
    return releases.all;
  }

  final versions = releases.all.where((version) {
    if (version.isChannel && version.name == filter.name) {
      return true;
    }

    if (!version.isChannel && version.release.channelName == filter.name) {
      return true;
    }

    return false;
  });

  return versions.toList();
});
