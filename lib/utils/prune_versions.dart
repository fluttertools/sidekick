import 'package:sidekick/dto/version.dto.dart';
import 'package:sidekick/providers/installed_versions.provider.dart';
import 'package:sidekick/providers/fvm_queue.provider.dart';
import 'package:sidekick/providers/flutter_projects_provider.dart';
import 'package:sidekick/utils/notify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> pruneVersionsDialog(BuildContext context) async {
  final toDelete = <VersionDto>[];
  final list = context.read(installedVersionsProvider);

  final projects = context.read(projectsPerVersionProvider);
  for (var version in list) {
    if (projects[version.name] == null) {
      toDelete.add(version);
    }
  }

  if (toDelete.isEmpty) {
    notify('No unused Flutter SDK versions installed');
    return;
  }

  if (projects.isEmpty) {
    notifyError(
        'No projects found. Cannot determine which versions to remove.');
    return;
  }

  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Prune unused versions'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: const Text("Cancel"),
              style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith(
                (states) => const EdgeInsets.all(20),
              )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Confirm"),
              style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith(
                (states) => const EdgeInsets.all(20),
              )),
              onPressed: () async {
                for (var version in toDelete) {
                  context.read(fvmQueueProvider).remove(version.name);
                }

                Navigator.of(context).pop();
              },
            ),
          ],
          content: Container(
            constraints: const BoxConstraints(maxWidth: 350),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '''The following versions are not being used by any project. Do you want to remove them to free up space?''',
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  direction: Axis.horizontal,
                  children: toDelete.map((v) {
                    return Chip(label: Text(v.name));
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      });
}
