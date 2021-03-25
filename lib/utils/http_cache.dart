import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// ignore: avoid_classes_with_only_static_members
class HttpCache {
  static const key = 'http_cache_manager';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 500,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}
