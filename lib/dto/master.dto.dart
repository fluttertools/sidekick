import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';

import 'channel.dto.dart';

/// Master channel dto
class MasterDto extends ChannelDto {
  /// Latest version of the channel

  MasterDto({
    @required String name,
    @required needSetup,
    @required String sdkVersion,
    @required CacheVersion cache,
    @required bool isGlobal,
  }) : super(
          name: name,
          needSetup: needSetup,
          sdkVersion: sdkVersion,
          release: null,
          currentRelease: null,
          cache: cache,
          isGlobal: isGlobal,
        );
}
