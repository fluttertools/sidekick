import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';
import 'package:sidekick/dto/version.dto.dart';

class ReleaseDto extends VersionDto {
  ReleaseDto({
    @required String name,
    @required bool isInstalled,
    @required Release release,
    @required bool needSetup,
  }) : super(
          name: name,
          release: release,
          isInstalled: isInstalled,
          needSetup: needSetup,
        );
}
