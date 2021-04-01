import 'package:github/github.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:sidekick/version.dart';

/// Latest Version update for package
class LatestVersion {
  final bool needUpdate;
  final String latestVersion;
  final String currentVersion;

  /// Constructor
  LatestVersion({
    this.needUpdate,
    this.latestVersion,
    this.currentVersion,
  });
}

/// Helper method to easily check for updates on [packageName]
/// comparing with [currentVersion] returns `LatestVersion`
Future<LatestVersion> checkLatestRelease() async {
  final latestRelease = await GitHub(
    auth: Authentication.anonymous(),
  ).repositories.getLatestRelease(RepositorySlug("leoafarias", "sidekick"));

  final latestVersion = Version.parse((latestRelease.tagName));
  final currentVersion = Version.parse(appVersion);

  final needUpdate = latestVersion > currentVersion;

  return LatestVersion(
    needUpdate: needUpdate,
    latestVersion: latestVersion.toString(),
    currentVersion: currentVersion.toString(),
  );
}
