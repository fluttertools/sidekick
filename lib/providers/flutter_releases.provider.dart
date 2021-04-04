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
  List<VersionDto> releases;
  Map<String, ReleaseDto> allMap;
  AppReleasesState({
    this.channels,
    this.releases,
    this.master,
    this.allMap,
  }) {
    channels = <ChannelDto>[];
    releases = <VersionDto>[];
    allMap = {};
  }

  /// Returns all releases and channels
  List<ReleaseDto> get all {
    final versions = [...channels, ...releases];
    if (master != null) {
      versions.insert(0, master);
    }

    return versions;
  }

  /// Returns all releases and channels that are cached
  List<ReleaseDto> get allCached {
    return all.where((version) => version.isCached).toList();
  }
}

final _fetchFlutterReleases = FutureProvider<FlutterReleases>(
  (_) => FVMClient.getFlutterReleases(),
);

// ignore: top_level_function_literal_block
final releasesStateProvider = Provider<AppReleasesState>((ref) {
  // Filter only version that are valid releases
  var payload = FlutterReleases();
  ref.watch(_fetchFlutterReleases).whenData((value) => payload = value);
  final installedVersions = ref.watch(fvmCacheProvider);

  // Watch this state change for refresh
  ref.watch(fvmCacheProvider.state);

  final flutterReleases = payload.releases;
  final flutterChannels = payload.channels;

  //Creates empty releases starte
  final releasesState = AppReleasesState();

  if (flutterReleases == null || installedVersions == null) {
    return releasesState;
  }

  // Set Master separetely because workflow is very different
  final masterCache = installedVersions.getChannel(kMasterChannel);
  final masterVersion = FVMClient.getSdkVersionSync(masterCache);

  releasesState.master = MasterDto(
    name: kMasterChannel,
    cache: masterCache,
    needSetup: masterVersion == null,
    sdkVersion: masterVersion,
  );

  // Loop through available channels NOT including master
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
    );

    releasesState.channels.add(channelDto);
  }

  for (var item in flutterReleases) {
    if (item == null) return null;

    // Check if version is found in installed versions
    final cacheVersion = installedVersions.getVersion(item.version);
    final sdkVersion = FVMClient.getSdkVersionSync(cacheVersion);

    final version = VersionDto(
      name: item.version,
      release: item,
      cache: cacheVersion,
      needSetup: sdkVersion == null,
    );

    releasesState.releases.add(version);
  }

  final allVersions = [...releasesState.releases, ...releasesState.channels];
  releasesState.allMap = {for (var v in allVersions) v.name: v};

  return releasesState;
});

final getVersionProvider =
    Provider.family<ReleaseDto, String>((ref, versionName) {
  final state = ref.watch(releasesStateProvider);
  return state.allMap[versionName];
});
