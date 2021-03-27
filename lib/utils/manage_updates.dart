import 'dart:io';

import 'package:sidekick/constants.dart';
import 'package:sidekick/utils/open_link.dart';
import 'package:flutter/cupertino.dart';
import 'package:github/github.dart';
//import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart' as provider;
import 'package:pub_semver/pub_semver.dart';

import '../components/molecules/update_card.dart';
import '../version.dart';

void downloadRelease(String release) async {
  String url;
  File file;

  var directory = await provider.getDownloadsDirectory();

  var fileLocation =
      "${directory.absolute.path}${Platform.pathSeparator}sidekick-$release.";

  if (Platform.isWindows) {
    url =
        "$kGithubSidekickUrl/releases/download/$release/Sidekick-windows-$release.msix";
    file = File("${fileLocation}msix");
  } else if (Platform.isWindows) {
    url =
        "$kGithubSidekickUrl/releases/download/$release/Sidekick-macos-$release.dmg";
    file = File("${fileLocation}dmg");
  }

  if (!await file.exists()) {
    showToast("Downloading...", duration: const Duration(seconds: 30));
    var res = await http.get(url);
    await file.writeAsBytes(res.bodyBytes);
    showToast("Release downloaded! Opening...", dismissOtherToast: true);
  } else {
    showToast("File already downloaded, opening...");
  }
  openInstaller(file);
}

void openInstaller(File file) {
  openLink("file://${file.absolute.path.replaceAll("\\", "/")}");
}

void checkForUpdates() async {
  var installedVersion;
  try {
    installedVersion = Version.parse(appVersion);
  } on FormatException catch (_) {
    return;
  }

  var latestRelease = await GitHub(
          // TODO: Add Custom token
          auth: Authentication.anonymous())
      .repositories
      .getLatestRelease(
        RepositorySlug("leoafarias", "sidekick"),
      );

  var latestVersion = Version.parse(latestRelease.tagName);

  if (latestVersion > installedVersion) {
    ToastFuture toast;

    void dismisstoast() {
      toast.dismiss(showAnim: true);
    }

    toast = showToastWidget(
      UpdateAvailableCard(() {
        downloadRelease(latestRelease.tagName);
        Future.delayed(const Duration(seconds: 1)).then((_) {
          dismisstoast();
        });
      }, dismisstoast),
      //backgroundColor: Colors.green,
      handleTouch: true,
      position: const ToastPosition(
        align: Alignment(0.95, 0.95),
      ),
      duration: const Duration(seconds: 60),
      //textPadding: const EdgeInsets.all(20),
    );
  }
}
