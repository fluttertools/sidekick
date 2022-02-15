import 'package:fvm/fvm.dart';

import 'release.dto.dart';

/// Releae channel dto
class ChannelDto extends ReleaseDto {
  /// Latest releae of a channel
  final Release? currentRelease;

  /// SDK Version
  final String? sdkVersion;

  /// Constructor
  ChannelDto({
    required String name,
    required Release? release,
    required CacheVersion? cache,
    required needSetup,
    required this.sdkVersion,
    required this.currentRelease,
    required isGlobal,
  }) : super(
          name: name,
          release: release,
          needSetup: needSetup,
          isChannel: true,
          cache: cache,
          isGlobal: isGlobal,
        );
}
