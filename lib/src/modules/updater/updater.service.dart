import 'package:github/github.dart';
import 'package:http/http.dart' as http;
import 'package:pub_semver/pub_semver.dart';

import '../../modules/common/utils/open_link.dart';
import '../../version.dart';
import '../common/constants.dart';
import 'updater.dto.dart';
import 'updater.utils.dart';

/// Handles app Sidekick updates
class UpdaterService {
  const UpdaterService._();

  /// Helper method to easily check for updates on [packageName]
  /// comparing with [current] returns `LatestVersion`
  static Future<SidekickUpdateInfo> checkLatestRelease() async {
    try {
      final latestRelease = await GitHub(
        auth: Authentication.anonymous(),
      ).repositories.getLatestRelease(kSidekickRepoSlug);

      final latestVersion = Version.parse((latestRelease.tagName));
      final currentVersion = Version.parse(packageVersion);

      final needUpdate = latestVersion > currentVersion;

      /// Check if it has downloaded
      final file = await getDownloadFileLocation(latestVersion.toString());
      final downloadUrl = await getDownloadReleaseUrl(latestVersion.toString());

      return SidekickUpdateInfo(
          needUpdate: needUpdate,
          current: currentVersion.toString(),
          latest: latestVersion.toString(),
          isInstalled: await file.exists(),
          latestDownloadUrl: downloadUrl,
          latestInstallerFile: file);
    } on Exception catch (err) {
      print(err.toString());
      return null;
    }
  }

  /// Download release
  static Future<SidekickUpdateInfo> downloadRelease(
    SidekickUpdateInfo updateInfo,
  ) async {
    if (updateInfo.isInstalled) {
      return updateInfo;
    } else {
      var res = await http.get(
        Uri.parse(updateInfo.latestDownloadUrl),
      );
      if (res.statusCode == 200) {
        await updateInfo.latestInstallerFile.writeAsBytes(res.bodyBytes);
        // Return with new installed status
        return updateInfo.copyWith(isInstalled: true);
      } else {
        throw UpdaterException(
          "There was an issue downloading the file, plese try again later.\n"
          "Code ${res.statusCode}",
        );
      }
    }
  }

  /// Open installer
  static Future<void> openInstaller(SidekickUpdateInfo updateInfo) async {
    if (updateInfo.isInstalled) {
      final file = updateInfo.latestInstallerFile;
      openLink("file://${file.absolute.path.replaceAll("\\", "/")}");
    } else {
      throw UpdaterException(
        'Installer does not exists, you have to download it first',
      );
    }
  }
}

/// Exception for updaters
class UpdaterException implements Exception {
  /// Message of erro
  final String message;

  /// Constructor
  const UpdaterException([this.message = '']);

  @override
  String toString() => '$message';
}
