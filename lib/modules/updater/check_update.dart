import 'package:github/github.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../version.dart';

/// Latest Version update for Sidekick
class SidekickUpdateInfo {
  /// Constructor
  SidekickUpdateInfo({
    this.needUpdate = false,
    this.latestVersion = '',
    this.currentVersion = appVersion,
  });

  /// Needs update
  final bool needUpdate;

  /// Latest version number
  final String latestVersion;

  /// Current version
  final String currentVersion;
}

/// Helper method to easily check for updates on [packageName]
/// comparing with [currentVersion] returns `LatestVersion`
Future<SidekickUpdateInfo> checkLatestRelease() async {
  try {
    final latestRelease = await GitHub(
      auth: Authentication.anonymous(),
    ).repositories.getLatestRelease(
          RepositorySlug(
            "leoafarias",
            "sidekick",
          ),
        );

    final latestVersion = Version.parse((latestRelease.tagName));
    final currentVersion = Version.parse(appVersion);

    final needUpdate = latestVersion > currentVersion;

    return SidekickUpdateInfo(
      needUpdate: needUpdate,
      latestVersion: latestVersion.toString(),
      currentVersion: currentVersion.toString(),
    );
  } on Exception catch (err) {
    print(err.toString());
    return SidekickUpdateInfo();
  }
}
