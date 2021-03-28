import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:state_notifier/state_notifier.dart';
import 'package:watcher/watcher.dart';
import 'package:sidekick/utils/debounce.dart';
import 'package:sidekick/utils/dir_stat.dart';

import 'package:fvm/constants.dart' as fvm_constants;
import 'package:fvm/fvm.dart';

@deprecated
enum InstalledStatus {
  notInstalled,
  asChannel,
  asVersion,
}

final fvmCacheSizeProvider = StateProvider<String>((_) => null);

/// Releases  InfoProvider
final fvmCacheProvider = StateNotifierProvider<FvmCacheProvider>((ref) {
  return FvmCacheProvider(ref: ref, initialState: []);
});

class FvmCacheProvider extends StateNotifier<List<CacheVersion>> {
  ProviderReference ref;
  List<CacheVersion> channels;
  List<CacheVersion> versions;

  StreamSubscription<WatchEvent> directoryWatcher;
  final _debouncer = Debouncer(milliseconds: 20000);

  FvmCacheProvider({
    this.ref,
    List<CacheVersion> initialState,
  }) : super(initialState) {
    reloadState();
    // Load State again while listening to directory
    directoryWatcher = Watcher(fvm_constants.kFvmHome).events.listen((event) {
      _debouncer.run(reloadState);
    });
  }

  Future<void> _setTotalCacheSize() async {
    final stat = await getDirectorySize(fvm_constants.kFvmCacheDir.path);
    ref.read(fvmCacheSizeProvider).state = stat.friendlySize;
  }

  Future<void> reloadState() async {
    // Cancel debounce to avoid running twice with no new state change
    _debouncer.cancel();
    final localVersions = await CacheService.getAllVersions();
    state = localVersions;

    channels = localVersions.where((item) => item.isChannel).toList();
    versions = localVersions.where((item) => item.isChannel == false).toList();
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
