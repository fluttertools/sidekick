import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvm/fvm.dart';

import '../../constants.dart';
import '../../dto/channel.dto.dart';
import '../../dto/master.dto.dart';
import '../../dto/release.dto.dart';
import '../../dto/version.dto.dart';
import '../fvm/fvm.provider.dart';

class AppReleasesState {
  MasterDto master;
  List<ChannelDto> channels;
  List<VersionDto> versions;
  Map<String, ReleaseDto> allMap;
  bool hasGlobal;
  AppReleasesState({
    this.channels,
    this.versions,
    this.master,
    this.allMap,
    this.hasGlobal = false,
  }) {
    channels = <ChannelDto>[];
    versions = <VersionDto>[];
    allMap = {};
  }

  /// Returns all releases and channels
  List<ReleaseDto> get all {
    final releases = [...channels, ...versions];
    if (master != null) {
      // Master goes first
      releases.insert(0, master);
    }

    return releases;
  }

  /// Returns all releases and channels that are cached
  List<ReleaseDto> get allCached {
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

final releasesStateProvider = Provider<AppReleasesState>((ref) {
  // Filter only version that are valid releases
  FlutterReleases payload;
  ref.watch(_fetchFlutterReleases).whenData((value) => payload = value);
  final installedVersions = ref.watch(fvmCacheProvider.notifier);

  // Watch this state change for refresh
  ref.watch(fvmCacheProvider);

//Creates empty releases state
  final releasesState = AppReleasesState();
  // Return empty state if not loaded
  if (payload == null) {
    return releasesState;
  }

  final flutterReleases = payload.releases;
  final flutterChannels = payload.channels;

  if (flutterReleases == null || installedVersions == null) {
    return releasesState;
  }

  final globalVersion = FVMClient.getGlobalVersionSync();
  releasesState.hasGlobal = globalVersion != null;

  //  MASTER: Set Master separetely because workflow is very different
  final masterCache = installedVersions.getChannel(kMasterChannel);
  String masterVersion;
  if (masterCache != null) {
    masterVersion = FVMClient.getSdkVersionSync(masterCache);
  }

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
    String sdkVersion;
    Release currentRelease;

    if (channelCache != null) {
      sdkVersion = FVMClient.getSdkVersionSync(channelCache);
      if (sdkVersion != null) {
        currentRelease = payload.getReleaseFromVersion(sdkVersion);
      }
    }

    final channelDto = ChannelDto(
      name: name,
      cache: channelCache,
      needSetup: sdkVersion == null,
      sdkVersion: sdkVersion,
      // Get version for the channel
      currentRelease: currentRelease,
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
    String sdkVersion;

    if (cacheVersion != null) {
      sdkVersion = FVMClient.getSdkVersionSync(cacheVersion);
    }

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
  final releases = ref.watch(releasesStateProvider);

  if (filter == Filter.all) {
    return releases.versions;
  }

  final versions = releases.versions.where((version) {
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
