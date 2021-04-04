import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';

abstract class ReleaseDto {
  final String name;
  Release release;
  CacheVersion cache;
  bool needSetup;
  bool isChannel;

  ReleaseDto({
    @required this.name,
    @required this.release,
    @required this.needSetup,
    @required this.cache,
    this.isChannel = false,
  });

  bool get isCached {
    return cache != null;
  }
}
