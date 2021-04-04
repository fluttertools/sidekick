import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';
import 'package:sidekick/dto/version.dto.dart';

class ReleaseDto extends VersionDto {
  ReleaseDto({
    @required String name,
    @required Release release,
    @required bool needSetup,
    @required CacheVersion cache,
  }) : super(
          name: name,
          release: release,
          needSetup: needSetup,
          cache: cache,
        );
}
