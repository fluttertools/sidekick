import 'package:sidekick/providers/flutter_releases.provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// ignore: top_level_function_literal_block
final masterProvider = Provider((ref) {
  return ref.watch(releasesStateProvider).master;
});
