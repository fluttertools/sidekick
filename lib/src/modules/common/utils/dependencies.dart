import 'package:pub_api_client/pub_api_client.dart';

import '../../packages/package.dto.dart';

final client = PubClient();

Map<String, PubPackage> mapPackages;

/// Fetches all packages info from pub.dev
Future<List<PackageDetail>> fetchPackages(
  Map<String, int> packagesCount,
) async {
  final pkgFutures = <Future<PubPackage>>[];

  // Get top packages

  for (var pkg in packagesCount.keys) {
    pkgFutures.add(client.packageInfo(pkg));
  }

  final packages = await Future.wait(pkgFutures, eagerError: true);

  final topPackages = _getTopValidPackages(packages, packagesCount);
  final results = await _complementPackageInfo(topPackages, packagesCount);

  return results;
}

List<PubPackage> _getTopValidPackages(
  List<PubPackage> packages,
  Map<String, int> packagesCount,
) {
  const max = 30;

  // Filter to only valid packages
  final validPackages = packages.where((dep) => dep.name != null).toList();

  // Sort descending based on count
  validPackages.sort(
    (p1, p2) => packagesCount[p2.name].compareTo(packagesCount[p1.name]),
  );

  // Limit number of results
  validPackages.length = max;

  return validPackages;
}

Future<List<PackageDetail>> _complementPackageInfo(
  List<PubPackage> packages,
  Map<String, int> packagesCount,
) async {
  final packagesDetail = <Future<PackageDetail>>[];

  for (var pkg in packages) {
    if (pkg != null) {
      packagesDetail.add(_assignInfo(pkg, packagesCount[pkg.name]));
    }
  }

  return await Future.wait(packagesDetail);
}

Future<PackageDetail> _assignInfo(PubPackage package, int count) async {
  final score = await client.packageScore(package.name);

  return PackageDetail(
    name: package.name,
    description: package.description,
    version: package.version,
    url: package.url,
    homepage: package.latestPubspec.homepage,
    changelogUrl: package.changelogUrl,
    score: score,
    projectsCount: count,
  );
}
