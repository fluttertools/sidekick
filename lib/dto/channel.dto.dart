import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';

import 'release.dto.dart';

class ChannelDto extends ReleaseDto {
  /// Latest version of the channel
  Release currentRelease;
  final String sdkVersion;

  ChannelDto({
    @required String name,
    @required Release release,
    @required CacheVersion cache,
    @required needSetup,
    @required this.sdkVersion,
    @required this.currentRelease,
    @required isGlobal,
  }) : super(
          name: name,
          release: release,
          needSetup: needSetup,
          isChannel: true,
          cache: cache,
          isGlobal: isGlobal,
        );
}
