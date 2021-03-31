import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/providers/flutter_releases.provider.dart';

// ignore: top_level_function_literal_block
final masterProvider = Provider((ref) {
  return ref.watch(releasesStateProvider).master;
});
