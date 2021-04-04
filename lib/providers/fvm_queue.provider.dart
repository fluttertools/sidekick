import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvm/fvm.dart';
import 'package:sidekick/dto/version.dto.dart';
import 'package:sidekick/providers/fvm_cache.provider.dart';
import 'package:sidekick/providers/projects_provider.dart';
import 'package:sidekick/providers/settings.provider.dart';
import 'package:sidekick/utils/notify.dart';
import 'package:state_notifier/state_notifier.dart';

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
  final VersionDto version;
  final QueueAction action;
  QueueItem({this.version, this.action});
}

enum QueueAction {
  setupOnly,
  install,
  installAndSetup,
  channelUpgrade,
  remove,
}

/// Releases Provider
final fvmQueueProvider = StateNotifierProvider<FvmQueueProvider>((ref) {
  return FvmQueueProvider(ref: ref);
});

class FvmQueueProvider extends StateNotifier<FvmQueue> {
  final ProviderReference ref;
  FvmQueueProvider({@required this.ref}) : super(null) {
    state = FvmQueue(activeItem: null, queue: Queue());
  }

  FvmSettings get settings {
    return ref.read(settingsProvider.state).fvm;
  }

  void install(VersionDto version, {bool skipSetup}) async {
    skipSetup ??= settings.skipSetup;
    final action =
        skipSetup ? QueueAction.install : QueueAction.installAndSetup;

    _addToQueue(version, action: action);
    runQueue();
  }

  void setup(VersionDto version) {
    _addToQueue(version, action: QueueAction.setupOnly);
    runQueue();
  }

  void upgrade(VersionDto version) {
    _addToQueue(version, action: QueueAction.channelUpgrade);
    runQueue();
  }

  void remove(VersionDto version) {
    _addToQueue(version, action: QueueAction.remove);
    runQueue();
  }

  void runQueue() async {
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
    try {
      switch (item.action) {
        case QueueAction.install:
          await FVMClient.install(item.version.name);
          notify('Version ${item.version.name} has been installed');
          break;
        case QueueAction.setupOnly:
          await FVMClient.setup(item.version.name);
          notify('Version ${item.version.name} has finished setup');
          break;
        case QueueAction.installAndSetup:
          await FVMClient.install(item.version.name);
          await FVMClient.setup(item.version.name);
          await notify('Version ${item.version.name} has been installed');
          break;
        case QueueAction.channelUpgrade:
          await FVMClient.upgradeChannel(item.version.name);
          notify('Channel ${item.version.name} has been upgraded');
          break;
        case QueueAction.remove:
          await FVMClient.remove(item.version.name);
          notify('Version ${item.version.name} has been removed');
          break;
        default:
          break;
      }
    } on Exception catch (e) {
      notifyError(e.toString());
    }
    // Check if action is to setup only

    // Set active item to null
    state.activeItem = null;
    // Run update on cache
    await ref.read(fvmCacheProvider).reloadState();
    // Update queue
    state = state.update();

    // Run queue again
    runQueue();
  }

  Future<void> pinVersion(Project project, String version) async {
    await FVMClient.pinVersion(project, version);
    await ref.read(projectsProvider).reloadOne(project);
    await notify('Version $version pinned to ${project.name}');
  }

  Future<void> _addToQueue(VersionDto version, {QueueAction action}) async {
    state.queue.add(QueueItem(version: version, action: action));
    state = state.update();
  }
}
