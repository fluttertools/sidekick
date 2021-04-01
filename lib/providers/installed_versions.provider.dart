// ignore: top_level_function_literal_block
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/providers/channels.provider.dart';
import 'package:sidekick/providers/flutter_releases.provider.dart';
import 'package:sidekick/providers/releases.provider.dart';

// ignore: top_level_function_literal_block
final installedVersionsProvider = Provider((ref) {
  final releases = ref.watch(installedReleasesProvider);
  final channels = ref.watch(installedChannelsProvider);
  final master = ref.watch(releasesStateProvider).master;
  final versions = [...channels.all, ...releases.all];
  // If channel is installed
  if (master != null && master.isInstalled) {
    versions.insert(0, master);
  }
  return versions;
});
