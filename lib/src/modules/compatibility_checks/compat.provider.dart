import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'compat.dto.dart';
import 'compat.service.dart';
import '../../modifiers.dart';

/// Updater provider
final compatProvider =
    StateNotifierProvider<UpdaterStateNotifier, CompatibilityCheck>(
        (_) => UpdaterStateNotifier());

/// Update state notifier
class UpdaterStateNotifier extends StateNotifier<CompatibilityCheck> {
  /// COnstructor
  UpdaterStateNotifier() : super(CompatibilityCheck.notReady()) {
    //TODO: Implement check
  }

  /// Check for latest release
  Future<void> checkRequirements() async {
    // TODO: Implement Check
  }
}
