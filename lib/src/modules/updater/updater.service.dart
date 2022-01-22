import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pub_semver/pub_semver.dart';

import '../../modules/common/utils/open_link.dart';
import '../../version.dart';
import '../common/constants.dart';
import 'updater.dto.dart';
import 'updater.utils.dart';

Future<String> getSidekickLatestRelease() async {
  final response = await Dio().get(kSidekickLatestReleaseUrl);

  return response.data['tag_name'];
}

/// Handles app Sidekick updates
class UpdaterService {
  const UpdaterService._();

  /// Helper method to easily check for updates on [packageName]
  /// comparing with [current] returns `LatestVersion`
  static Future<SidekickUpdateInfo> checkLatestRelease() async {
    try {
      final latestTag = await getSidekickLatestRelease();
      final latestVersion = Version.parse((latestTag));
      final currentVersion = Version.parse(packageVersion);

      final needUpdate = latestVersion > currentVersion;

      /// Check if it has downloaded
      final file = await getDownloadFileLocation(latestVersion.toString());
      final downloadUrl = getDownloadReleaseUrl(latestVersion.toString());

      return SidekickUpdateInfo(
          needUpdate: needUpdate,
          current: currentVersion.toString(),
          latest: latestVersion.toString(),
          isInstalled: await file.exists(),
          latestDownloadUrl: downloadUrl,
          latestInstallerFile: file);
    } on Exception catch (_) {
      //print(err.toString());
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
          'There was an issue downloading the file, plese try again later.\n'
          'Code ${res.statusCode}',
        );
      }
    }
  }

  /// Open installer
  static Future<void> openInstaller(
      BuildContext context, SidekickUpdateInfo updateInfo) async {
    if (updateInfo.isInstalled) {
      final file = updateInfo.latestInstallerFile;
      await openLink(
          context, "file://${file.absolute.path.replaceAll("\\", "/")}");
    } else {
      throw const UpdaterException(
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
  String toString() => message;
}
