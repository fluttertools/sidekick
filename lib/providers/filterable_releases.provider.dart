import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/providers/releases.provider.dart';

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
final filterableReleasesProvider = Provider((ref) {
  final filter = ref.watch(filterProvider).state;
  final versions = ref.watch(releasesProvider);
  // var return <ReleaseDto>[];

  switch (filter) {
    case Filter.stable:
      return versions.stable;
    case Filter.beta:
      return versions.beta;
    case Filter.dev:
      return versions.dev;
    case Filter.all:
      return versions.all;
    default:
      return [];
  }
});
