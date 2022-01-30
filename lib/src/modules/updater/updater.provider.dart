import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'updater.dto.dart';
import 'updater.service.dart';
import '../../modifiers.dart';

/// Updater provider
final updaterProvider =
    StateNotifierProvider<UpdaterStateNotifier, SidekickUpdateInfo>(
        (_) => UpdaterStateNotifier());

/// Update state notifier
class UpdaterStateNotifier extends StateNotifier<SidekickUpdateInfo> {
  /// COnstructor
  UpdaterStateNotifier() : super(SidekickUpdateInfo.notReady()) {
    if (!isMSStore) checkLatest();
  }

  /// Check for latest release
  Future<void> checkLatest() async {
    state = await UpdaterService.checkLatestRelease();
    if (state.needUpdate && !state.isInstalled) {
      await download();
    }
  }

  /// Download latest release
  Future<void> download() async {
    state = await UpdaterService.downloadRelease(state);
  }

  /// Opens installer
  Future<void> openInstaller(BuildContext context) async {
    await UpdaterService.openInstaller(context, state);
  }
}
