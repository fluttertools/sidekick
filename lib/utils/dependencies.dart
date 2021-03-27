import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:pubspec_parse/pubspec_parse.dart';

import 'package:github/github.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:flutter_cache/flutter_cache.dart' as cache;
import 'package:sidekick/dto/package_detail.dto.dart';

const cacheKey = 'dependencies_cache_key';

final client = PubClient();

final github = GitHub(
  auth: Authentication.anonymous(),
);

Map<String, PubPackage> mapPackages;

/// Fetches all packages info from pub.dev
Future<List<PackageDetail>> fetchAllDependencies(
    Map<String, int> packagesCount) async {
  final response = await cache.remember(
    cacheKey,
    () async {
      final pkgFutures = <Future<PubPackage>>[];

      // Get top packages

      for (var pkg in packagesCount.keys) {
        pkgFutures.add(client.packageInfo(pkg));
      }

      final packages = await Future.wait(pkgFutures);
      final topPackages = _getTopValidPackages(packages, packagesCount);
      final results = await _complementPackageInfo(topPackages, packagesCount);

      return jsonEncode(results);
    },
    Duration.secondsPerDay,
  );
  final json = jsonDecode(response) as List<dynamic>;
  return json.map((value) => PackageDetail.fromJson(value)).toList();
}

List<PubPackage> _getTopValidPackages(
  List<PubPackage> packages,
  Map<String, int> packagesCount,
) {
  const max = 10;

  // Filter to only valid packages
  final validPackages = packages.where((dep) => dep.name != null).toList();
  final mapValidPackages = Map<String, PubPackage>.fromIterable(validPackages,
      key: (v) => v.name, value: (v) => v);

  // Sort based on count
  final sortedKeys = mapValidPackages.keys.toList()
    ..sort((k1, k2) => packagesCount[k1].compareTo(packagesCount[k2]));

  final reversedSortedKeys = sortedKeys.reversed.toList();

  // Limit number of results
  reversedSortedKeys.length = max;

  /// Return only PubPackages within the top keys
  return reversedSortedKeys.map((key) => mapValidPackages[key]).toList();
}

Future<List<PackageDetail>> _complementPackageInfo(
  List<PubPackage> packages,
  Map<String, int> packagesCount,
) async {
  final packagesDetail = <Future<PackageDetail>>[];

  for (var pkg in packages) {
    packagesDetail.add(_assignInfo(pkg, packagesCount[pkg.name]));
  }

  return await Future.wait(packagesDetail);
}

RepositorySlug _getRepoSlug(Pubspec pubspec) {
  String author;
  String repo;

  if (pubspec.repository != null) {
    final paths = pubspec.repository.path.split('/');
    author = paths[1];
    repo = paths[2];
  } else {
    if (pubspec.homepage != null && pubspec.homepage.contains('github.com')) {
      final uri = Uri.parse(pubspec.homepage);
      final paths = uri.path.split('/');
      author = paths[1];
      repo = paths[2];
    }
  }
  if (author != null && repo != null) {
    return RepositorySlug(author, repo);
  } else {
    return null;
  }
}

Future<PackageDetail> _assignInfo(PubPackage package, int count) async {
  final score = await client.packageScore(package.name);
  Repository repo;
  try {
    repo = await github.repositories
        .getRepository(_getRepoSlug(package.latestPubspec));
  } on Exception {
    repo = null;
  }
  return PackageDetail(
    name: package.name,
    description: package.description,
    version: package.version,
    url: package.url,
    homepage: package.latestPubspec.homepage,
    changelogUrl: package.changelogUrl,
    score: score,
    count: count,
    repo: repo,
  );
}
