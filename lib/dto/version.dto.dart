import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';

import 'release.dto.dart';

class VersionDto extends ReleaseDto {
  VersionDto({
    @required String name,
    @required Release release,
    @required bool needSetup,
    @required CacheVersion cache,
    @required bool isGlobal,
  }) : super(
          name: name,
          release: release,
          needSetup: needSetup,
          cache: cache,
          isGlobal: isGlobal,
        );
}
