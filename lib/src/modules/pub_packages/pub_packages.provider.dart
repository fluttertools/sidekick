// ignore_for_file: top_level_function_literal_block
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:sidekick/src/modules/pub_packages/dto/flutter_favorite.dto.dart';
import 'package:sidekick/src/modules/pub_packages/dto/pub_package.dto.dart';
import 'package:sidekick/src/modules/pub_packages/dto/trending_package.dto.dart';

import '../../modules/common/utils/dependencies.dart';
import '../projects/projects.provider.dart';

const trendingTodayUrl =
    'https://raw.githubusercontent.com/leoafarias/flutter_flat_data/main/trending-repository-today.json';

final githubTrendingProvider = FutureProvider<List<TrendingPackage>>(
  (ref) async {
    final response = await Dio().get(trendingTodayUrl);
    final data = jsonDecode(response.data);
    final packages = <TrendingPackage>[];
    for (final item in data) {
      packages.add(TrendingPackage.fromMap(item));
    }

    return packages;
  },
);

const flutterFavoritesUrl =
    'https://raw.githubusercontent.com/leoafarias/flutter_flat_data/main/flutter-favorites.json';

final flutterFavoritesProvider = FutureProvider<List<FlutterFavorite>>(
  (ref) async {
    final response = await Dio().get(flutterFavoritesUrl);
    final data = jsonDecode(response.data);
    final favorites = <FlutterFavorite>[];
    for (final item in data) {
      favorites.add(
        FlutterFavorite.fromMap(item),
      );
    }

    return favorites;
  },
);

/// Project packages
final packagesProvider = FutureProvider((ref) async {
  final projects = ref.watch(projectsProvider);

  final packages = <String, int>{};

  if (projects.isEmpty) {
    return <PackageDetail>[];
  }

  // Retrieve cache if exits

  // Get dependencies
  final googleDeps = await getGooglePackages();
  for (final project in projects) {
    final pubspec = project.pubspec;
    final deps = pubspec.dependencies;

    for (final dep in deps.keys) {
      // Get google deps

      if (deps[dep] is HostedDependency && googleDeps.contains(dep) == false) {
        // Increment count or set it to 1 if has not been set
        packages.update(dep, (val) => ++val, ifAbsent: () => 1);
      }
    }
  }

  return fetchPackages(packages);
});
