import 'dart:io';

import 'package:flutter/material.dart';

/// Latest Version update for Sidekick
class SidekickUpdateInfo {
  /// Constructor
  SidekickUpdateInfo({
    @required this.needUpdate,
    @required this.isInstalled,
    @required this.current,
    @required this.latest,
    @required this.latestDownloadUrl,
    @required this.latestInstallerFile,
  });

  /// Needs update
  final bool needUpdate;

  /// Latest version number
  final String latest;

  /// Current version
  final String current;

  /// Local installer file
  final File latestInstallerFile;

  /// Latest release download url
  final String latestDownloadUrl;

  /// Is update intalled
  bool isInstalled;

  /// Need update and ready to install
  bool get ready {
    return needUpdate && !isInstalled;
  }

  /// Clones sidekick update
  SidekickUpdateInfo copyWith({
    bool needUpdate,
    bool isInstalled,
    String current,
    String latest,
    String latestDownloadUrl,
    File latestInstallerFile,
  }) {
    return SidekickUpdateInfo(
      needUpdate: needUpdate ?? this.needUpdate,
      isInstalled: isInstalled ?? this.isInstalled,
      current: current ?? this.current,
      latest: latest ?? this.latest,
      latestDownloadUrl: latestDownloadUrl ?? this.latestDownloadUrl,
      latestInstallerFile: latestInstallerFile ?? this.latestInstallerFile,
    );
  }
}
