import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';
import 'package:sidekick/dto/channel.dto.dart';

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
