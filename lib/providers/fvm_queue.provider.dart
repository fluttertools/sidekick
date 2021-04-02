import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvm/fvm.dart';
import 'package:sidekick/providers/flutter_projects_provider.dart';
import 'package:sidekick/providers/fvm_cache.provider.dart';
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
  final String name;
  final QueueAction action;
  QueueItem({this.name, this.action});
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

  void install(String version, {bool skipSetup}) async {
    skipSetup ??= settings.skipSetup;
    final action =
        skipSetup ? QueueAction.install : QueueAction.installAndSetup;

    _addToQueue(version, action: action);
    runQueue();
  }

  void setup(String version) {
    _addToQueue(version, action: QueueAction.setupOnly);
    runQueue();
  }

  void upgrade(String version) {
    _addToQueue(version, action: QueueAction.channelUpgrade);
    runQueue();
  }

  void remove(String version) {
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
    switch (item.action) {
      case QueueAction.install:
        await FVMClient.install(item.name);
        notify('Version ${item.name} has been installed');
        break;
      case QueueAction.setupOnly:
        await FVMClient.setup(item.name);
        await notify('Version ${item.name} has finished setup.');
        notify('Version ${item.name} has finished setup');
        break;
      case QueueAction.installAndSetup:
        await FVMClient.install(item.name);
        await FVMClient.setup(item.name);
        await notify('Version ${item.name} has been installed');
        break;
      case QueueAction.channelUpgrade:
        await FVMClient.upgradeChannel(item.name);
        notify('Channel ${item.name} has been upgraded');
        break;
      case QueueAction.remove:
        await FVMClient.remove(item.name);
        notify('Version ${item.name} has been removed');
        break;
      default:
        break;
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

  Future<void> _addToQueue(String version, {QueueAction action}) async {
    state.queue.add(QueueItem(name: version, action: action));
    state = state.update();
  }
}
