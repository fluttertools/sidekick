import 'dart:convert';

import 'package:flutter_cache/flutter_cache.dart' as cache;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:sidekick/dto/package_detail.dto.dart';
import 'package:sidekick/providers/projects_provider.dart';
import 'package:sidekick/services/settings_service.dart';
import 'package:sidekick/utils/dependencies.dart';

const cacheKey = 'dependencies_cache_key';
// Used to invalidate the cache
const cacheRefKey = 'cache_ref_key';

// ignore: top_level_function_literal_block
final packagesProvider = FutureProvider((ref) async {
  final projects = ref.watch(projectsProvider);

  final packages = <String, int>{};

  if (projects.list.isEmpty) {
    return [];
  }

  final settings = SettingsService.read();
  final cacheRef = await cache.load(cacheRefKey);

  /// Save directory as a cache reference
  /// Once directory changes drop the reference
  if (settings.firstProjectDir != cacheRef) {
    cache.destroy(cacheKey);
    cache.remember(cacheRefKey, settings.firstProjectDir);
  }

  // Retrieve cache if exits
  final cacheRes = await cache.load(cacheKey);

  // Return cache if it exists
  if (cacheRes != null) {
    final json = jsonDecode(cacheRes) as List<dynamic>;
    return json.map((value) => PackageDetail.fromJson(value)).toList();
  } else {
    // Get dependencies
    for (final project in projects.list) {
      final pubspec = project.pubspec;
      final deps = pubspec.dependencies;

      for (final dep in deps.keys) {
        // Get google deps
        final googleDeps = await getGooglePackages();

        if (deps[dep] is HostedDependency &&
            googleDeps.contains(dep) == false) {
          // Increment count or set it to 1 if has not been set
          packages.update(dep, (val) => ++val, ifAbsent: () => 1);
        }
      }
    }

    final packageList = await fetchPackages(packages);
    // Set cache for 1 day
    await cache.remember(
      cacheKey,
      jsonEncode(packageList),
      Duration.secondsPerDay,
    );
    return packageList;
  }
});
