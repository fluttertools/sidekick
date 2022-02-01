import 'package:flutter/material.dart';

/// Latest Version update for Sidekick
class CompatibilityCheck {
  /// Constructor
  CompatibilityCheck({
    @required this.git,
    @required this.fvm,
    @required this.choco,
    @required this.brew,
  });

  ///
  factory CompatibilityCheck.notReady() {
    return CompatibilityCheck(
      brew: false,
      choco: false,
      fvm: false,
      git: false,
    );
  }

  /// Git Install Status
  bool git;

  /// FVM Install Status
  bool fvm;

  /// Cohocolately Install Status
  bool choco;

  /// Brew Install Status
  bool brew;

  /// Need update and ready to install
  bool get ready {
    return fvm && git;
  }
}
