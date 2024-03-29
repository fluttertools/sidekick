import 'package:fvm/fvm.dart';

/// Flutter Relelease
abstract class ReleaseDto {
  /// Constructor
  ReleaseDto({
    required this.name,
    required this.needSetup,
    required this.cache,
    required this.release,
    this.isChannel = false,
    this.isGlobal = false,
  });

  /// Name
  final String name;

  /// Release
  Release? release;

  /// Cached release
  CacheVersion? cache;

  /// If needs setup
  bool needSetup;

  /// Is a channel
  bool isChannel;

  /// Is global
  bool isGlobal;

  /// Is releaes cached
  bool get isCached {
    return cache != null;
  }
}
