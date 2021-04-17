import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/dto/release.dto.dart';
import 'package:sidekick/providers/flutter_releases.provider.dart';
import 'package:sidekick/providers/projects_provider.dart';
import 'package:sidekick/utils/debounce.dart';
import 'package:sidekick/utils/dir_stat.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:watcher/watcher.dart';

final cacheSizeProvider =
    StateProvider<DirectorySizeInfo>((_) => DirectorySizeInfo());

// ignore: top_level_function_literal_block
final unusedCacheSizeProvider = FutureProvider((ref) {
  final unused = ref.watch(unusedVersionProvider);
  // Get all directories
  final directories = unused.map((version) => version.cache.dir).toList();
  return getDirectoriesSize(directories);
});

/// Provider that shows
// ignore: top_level_function_literal_block
final unusedVersionProvider = Provider((ref) {
  final unusedVersions = <ReleaseDto>[];

  /// Cannot use fvmCacheProvider to use remove action
  final releases = ref.watch(releasesStateProvider);

  final projects = ref.watch(projectsPerVersionProvider);
  for (var version in releases.allCached) {
    // If its not in project and its not global
    if (projects[version.name] == null && version.isGlobal == false) {
      unusedVersions.add(version);
    }
  }

  return unusedVersions;
});

/// Releases  InfoProvider
final fvmCacheProvider = StateNotifierProvider<FvmCacheProvider>((ref) {
  return FvmCacheProvider(ref: ref);
});

class FvmCacheProvider extends StateNotifier<List<CacheVersion>> {
  FvmCacheProvider({
    this.ref,
  }) : super([]) {
    reloadState();
    // Load State again while listening to directory
    directoryWatcher =
        Watcher(FVMClient.context.cacheDir.path).events.listen((event) {
      _debouncer.run(reloadState);
    });
  }

  ProviderReference ref;
  List<CacheVersion> channels;
  List<CacheVersion> versions;
  CacheVersion global;
  List<CacheVersion> all;

  StreamSubscription<WatchEvent> directoryWatcher;
  final _debouncer = Debouncer(const Duration(seconds: 20));

  Future<void> _setTotalCacheSize() async {
    final stat = await getDirectorySize(FVMClient.context.cacheDir);
    ref.read(cacheSizeProvider).state = stat;
  }

  Future<void> reloadState() async {
    // Cancel debounce to avoid running twice with no new state change
    _debouncer.cancel();
    final localVersions = await FVMClient.getCachedVersions();
    state = localVersions;

    channels = localVersions.where((item) => item.isChannel).toList();
    versions = localVersions.where((item) => item.isChannel == false).toList();
    all = [...channels, ...versions];
    _setTotalCacheSize();
  }

  CacheVersion getChannel(String name) {
    return channels.firstWhere(
      (c) => c.name == name,
      orElse: () => null,
    );
  }

  CacheVersion getVersion(String name) {
    // ignore: avoid_function_literals_in_foreach_calls
    return versions.firstWhere(
      (v) => v.name == name,
      orElse: () => null,
    );
  }

  @override
  void dispose() {
    directoryWatcher.cancel();
    super.dispose();
  }
}
