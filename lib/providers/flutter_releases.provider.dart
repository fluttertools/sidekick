import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvm/fvm.dart';
import 'package:sidekick/constants.dart';
import 'package:sidekick/dto/channel.dto.dart';
import 'package:sidekick/dto/master.dto.dart';
import 'package:sidekick/dto/release.dto.dart';
import 'package:sidekick/dto/version.dto.dart';
import 'package:sidekick/providers/fvm_cache.provider.dart';

class AppReleasesState {
  MasterDto master;
  List<ChannelDto> channels;
  List<VersionDto> versions;
  Map<String, ReleaseDto> allMap;
  AppReleasesState({
    this.channels,
    this.versions,
    this.master,
    this.allMap,
  }) {
    channels = <ChannelDto>[];
    versions = <VersionDto>[];
    allMap = {};
  }

  /// Returns all releases and channels
  List<ReleaseDto> get all {
    final releases = [...channels, ...versions];
    if (master != null) {
      releases.insert(0, master);
    }

    return releases;
  }

  /// Returns all releases and channels that are cached
  List<ReleaseDto> get allCached {
    // final versionNames = all.map((version) => version.name).toSet();
    // final _allCached = all.where((release) => release.isCached).toList();
    // _allCached.retainWhere((version) => versionNames.remove(version.name));

    // Only get unique cached releases
    // Some releases replicate across channels
    // They can only be installed once and conflict
    return allMap.entries
        .where((entry) => entry.value.isCached)
        .map((entry) => entry.value)
        .toList();
  }
}

final _fetchFlutterReleases = FutureProvider<FlutterReleases>(
  (_) => FVMClient.getFlutterReleases(),
);

// ignore: top_level_function_literal_block
final releasesStateProvider = Provider<AppReleasesState>((ref) {
  // Filter only version that are valid releases
  FlutterReleases payload;
  ref.watch(_fetchFlutterReleases).whenData((value) => payload = value);
  final installedVersions = ref.watch(fvmCacheProvider.notifier);
  final globalVersion = FVMClient.getGlobalVersionSync();

  // Watch this state change for refresh
  ref.watch(fvmCacheProvider);

  final flutterReleases = payload.releases;
  final flutterChannels = payload.channels;

  //Creates empty releases state
  final releasesState = AppReleasesState();

  if (flutterReleases == null || installedVersions == null) {
    return releasesState;
  }

  //  MASTER: Set Master separetely because workflow is very different
  final masterCache = installedVersions.getChannel(kMasterChannel);
  final masterVersion = FVMClient.getSdkVersionSync(masterCache);

  releasesState.master = MasterDto(
    name: kMasterChannel,
    cache: masterCache,
    needSetup: masterVersion == null,
    sdkVersion: masterVersion,
    isGlobal: globalVersion == kMasterChannel,
  );

  // CHANNELS: Loop through available channels NOT including master
  for (var name in kReleaseChannels) {
    final latestRelease = flutterChannels[name];
    final channelCache = installedVersions.getChannel(name);

    // Get sdk version
    final sdkVersion = FVMClient.getSdkVersionSync(channelCache);

    final channelDto = ChannelDto(
      name: name,
      cache: channelCache,
      needSetup: sdkVersion == null,
      sdkVersion: sdkVersion,
      // Get version for the channel
      currentRelease: payload.getReleaseFromVersion(sdkVersion),
      release: latestRelease,
      isGlobal: globalVersion == name,
    );

    releasesState.channels.add(channelDto);
  }

  // VERSIONS loop to create versions
  for (final item in flutterReleases) {
    if (item == null) return null;

    // Check if version is found in installed versions
    final cacheVersion = installedVersions.getVersion(item.version);
    final sdkVersion = FVMClient.getSdkVersionSync(cacheVersion);

    final version = VersionDto(
      name: item.version,
      release: item,
      cache: cacheVersion,
      needSetup: sdkVersion == null,
      isGlobal: globalVersion == item.version,
    );

    releasesState.versions.add(version);
  }

  /// Create a map with all the versions
  final allVersions = [...releasesState.versions, ...releasesState.channels];
  releasesState.allMap = {
    for (var version in allVersions) version.name: version
  };

  return releasesState;
});

final getVersionProvider =
    Provider.family<ReleaseDto, String>((ref, versionName) {
  final state = ref.watch(releasesStateProvider);
  return state.allMap[versionName];
});
