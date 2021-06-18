// ignore_for_file: top_level_function_literal_block
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:sidekick/src/modules/packages/trending_package.dto.dart';

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

/// Project packages
final packagesProvider = FutureProvider((ref) async {
  final projects = ref.watch(projectsProvider);

  final packages = <String, int>{};

  if (projects.isEmpty) {
    return [];
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

  final packageList = await fetchPackages(packages);

  return packageList;
});
