import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvm/fvm.dart';
import 'package:sidekick/dto/release.dto.dart';
import 'package:sidekick/providers/fvm_cache.provider.dart';
import 'package:sidekick/providers/projects_provider.dart';
import 'package:sidekick/providers/settings.provider.dart';
import 'package:sidekick/utils/notify.dart';
import 'package:state_notifier/state_notifier.dart';

import '../utils/notify.dart';

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
final fvmQueueProvider = StateNotifierProvider<FvmQueueProvider, FvmQueue>((ref) {
  return FvmQueueProvider(ref: ref);
});

class FvmQueueProvider extends StateNotifier<FvmQueue> {
  final ProviderReference ref;
  FvmQueueProvider({@required this.ref}) : super(null) {
    state = FvmQueue(activeItem: null, queue: Queue());
  }

  FvmSettings get settings {
    return ref.read(settingsProvider).fvm;
  }

  void install(ReleaseDto version, {bool skipSetup}) async {
    skipSetup ??= settings.skipSetup;
    final action =
        skipSetup ? QueueAction.install : QueueAction.installAndSetup;

    _addToQueue(version, action: action);
  }

  void setup(ReleaseDto version) {
    _addToQueue(version, action: QueueAction.setupOnly);
  }

  void upgrade(ReleaseDto version) {
    _addToQueue(version, action: QueueAction.channelUpgrade);
  }

  void remove(ReleaseDto version) {
    _addToQueue(version, action: QueueAction.remove);
  }

  void setGloabl(ReleaseDto version) {
    _addToQueue(version, action: QueueAction.setGlobal);
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
    // Check if action is to setup only

    // Set active item to null
    state.activeItem = null;
    // Run update on cache
    await ref.read(fvmCacheProvider.notifier).reloadState();
    // Update queue
    state = state.update();

    // Run queue again
    runQueue();
  }

  Future<void> pinVersion(Project project, String version) async {
    await FVMClient.pinVersion(project, version);
    await ref.read(projectsProvider.notifier).reloadOne(project);
    await notify('Version $version pinned to ${project.name}');
  }

  Future<void> _addToQueue(ReleaseDto version, {QueueAction action}) async {
    state.queue.add(QueueItem(version: version, action: action));
    state = state.update();
    runQueue();
  }
}
