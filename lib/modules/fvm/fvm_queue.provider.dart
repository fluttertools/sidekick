import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvm/fvm.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../dto/release.dto.dart';
import '../../utils/notify.dart';
import '../projects/project.dto.dart';
import '../projects/projects.provider.dart';
import '../settings/settings.provider.dart';
import 'fvm.provider.dart';

class FvmQueue {
  QueueItem activeItem;
  final Queue<QueueItem> queue;
  FvmQueue({@required this.activeItem, @required this.queue});

  bool get isEmpty {
    return queue.isEmpty;
  }

  QueueItem get next {
    activeItem = queue.removeFirst();
    return activeItem;
  }

  FvmQueue update() {
    return FvmQueue(activeItem: activeItem, queue: queue);
  }
}

class QueueItem {
  final ReleaseDto version;
  final QueueAction action;
  QueueItem({this.version, this.action});
}

enum QueueAction {
  setupOnly,
  install,
  installAndSetup,
  channelUpgrade,
  remove,
  setGlobal,
}

/// Releases Provider
final fvmQueueProvider = StateNotifierProvider<FvmQueueState, FvmQueue>((ref) {
  return FvmQueueState(ref: ref);
});

/// State of the FVM Queue
class FvmQueueState extends StateNotifier<FvmQueue> {
  /// Constructor
  FvmQueueState({@required this.ref}) : super(null) {
    state = FvmQueue(activeItem: null, queue: Queue());
  }

  /// Provider ref to be used later
  final ProviderReference ref;

  /// Retrieve FVM Settings
  FvmSettings get settings {
    return ref.read(settingsProvider).fvm;
  }

  ///  Adds install action to queue
  void install(ReleaseDto version, {bool skipSetup}) async {
    skipSetup ??= settings.skipSetup;
    final action =
        skipSetup ? QueueAction.install : QueueAction.installAndSetup;

    _addToQueue(version, action: action);
  }

  /// Adds setup action to queue
  void setup(ReleaseDto version) {
    _addToQueue(version, action: QueueAction.setupOnly);
  }

  /// adds upgrade action to queue
  void upgrade(ReleaseDto version) {
    _addToQueue(version, action: QueueAction.channelUpgrade);
  }

  /// Adds remove action to queue
  void remove(ReleaseDto version) {
    _addToQueue(version, action: QueueAction.remove);
  }

  /// Adds set global action to queue
  void setGlobal(ReleaseDto version) {
    _addToQueue(version, action: QueueAction.setGlobal);
  }

  /// Runs queue
  void runQueue() async {
    try {
      final queue = state.queue;
      final activeItem = state.activeItem;
      // No need to run if empty
      if (queue.isEmpty) return;
      // If currently installing a version
      if (activeItem != null) return;
      // Gets next item of the queue
      final item = state.next;
      // Update queue
      state = state.update();

      // Run through actions
      switch (item.action) {
        case QueueAction.install:
          await FVMClient.install(item.version.name);
          notify('Version ${item.version.name} has been installed.');
          break;
        case QueueAction.setupOnly:
          await FVMClient.setup(item.version.name);
          notify('Version ${item.version.name} has finished setup.');
          break;
        case QueueAction.installAndSetup:
          await FVMClient.install(item.version.name);
          await FVMClient.setup(item.version.name);
          await notify('Version ${item.version.name} has been installed.');
          break;
        case QueueAction.channelUpgrade:
          await FVMClient.upgradeChannel(item.version.cache);
          notify('Channel ${item.version.name} has been upgraded.');
          break;
        case QueueAction.remove:
          await FVMClient.remove(item.version.name);
          notify('Version ${item.version.name} has been removed.');
          break;
        case QueueAction.setGlobal:
          await FVMClient.setGlobalVersion(item.version.cache);
          notify('Version ${item.version.name} has been set as global.');
          break;
        default:
          break;
      }
    } on Exception catch (e) {
      notifyError(e.toString());
    }

    // Set active item to null
    state.activeItem = null;
    // Run update on cache
    await ref.read(fvmCacheProvider.notifier).reloadState();
    // Update queue
    state = state.update();

    // Run queue again
    runQueue();
  }

  /// Pins a releae to a project
  Future<void> pinVersion(FlutterProject project, String version) async {
    await FVMClient.pinVersion(project, version);
    await ref.read(projectsProvider.notifier).reload(project);
    await notify('Version $version pinned to ${project.name}');
  }

  Future<void> _addToQueue(ReleaseDto version, {QueueAction action}) async {
    state.queue.add(QueueItem(version: version, action: action));
    state = state.update();
    runQueue();
  }
}
