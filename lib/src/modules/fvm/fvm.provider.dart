// ignore_for_file: top_level_function_literal_block
import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:watcher/watcher.dart';

import '../../modules/common/dto/release.dto.dart';
import '../../modules/common/utils/debounce.dart';
import '../../modules/common/utils/dir_stat.dart';
import '../projects/projects.provider.dart';
import '../releases/releases.provider.dart';

/// Cache provider
final cacheSizeProvider =
    StateProvider<DirectorySizeInfo>((_) => DirectorySizeInfo());

/// Unused

final unusedReleaseSizeProvider = FutureProvider((ref) {
  final unused = ref.watch(unusedVersionProvider);
  // Get all directories
  final directories = unused.map((version) => version.cache.dir).toList();
  return getDirectoriesSize(directories);
});

/// Provider that shows
final unusedVersionProvider = Provider((ref) {
  final unusedVersions = <ReleaseDto>[];

  /// Cannot use fvmCacheProvider to use remove action
  final releases = ref.watch(releasesStateProvider);

  final projects = ref.watch(projectsPerVersionProvider);
  for (var version in releases.all) {
    // If its not in project and its not global
    if (projects[version.name] == null && version.isGlobal == false) {
      unusedVersions.add(version);
    }
  }

  return unusedVersions;
});

/// Releases  InfoProvider
final fvmCacheProvider =
    StateNotifierProvider<FvmCacheProvider, List<CacheVersion>>((ref) {
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
  List<CacheVersion> channels = [];
  List<CacheVersion> versions = [];
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
    await _setTotalCacheSize();
  }

  CacheVersion getChannel(String name) {
    if (channels.isNotEmpty) {
      return channels.firstWhere(
        (c) => c.name == name,
        orElse: () => null,
      );
    } else {
      return null;
    }
  }

  CacheVersion getVersion(String name) {
    if (versions.isNotEmpty) {
      // ignore: avoid_function_literals_in_foreach_calls
      return versions.firstWhere(
        (v) => v.name == name,
        orElse: () => null,
      );
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    directoryWatcher.cancel();
    super.dispose();
  }
}

final fvmStdoutProvider = StreamProvider.autoDispose((ref) {
  return StreamGroup.merge([
    FVMClient.console.stdout.stream,
    FVMClient.console.stderr.stream,
    FVMClient.console.warning.stream,
    FVMClient.console.info.stream,
    FVMClient.console.fine.stream,
    FVMClient.console.error.stream,
  ])
      .transform(utf8.decoder)
      // .transform(const LineSplitter())
      .asBroadcastStream();
});
