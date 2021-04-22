import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/dto/release.dto.dart';
import 'package:sidekick/providers/fvm_queue.provider.dart';

class ProjectVersionSelect extends StatelessWidget {
  final Project project;
  final List<ReleaseDto> versions;

  const ProjectVersionSelect({
    @required this.project,
    @required this.versions,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
        tooltip: 'Select a Flutter SDK Version',

        // elevation: 1,
        padding: EdgeInsets.zero,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
          constraints: const BoxConstraints(
            maxWidth: 165,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              project.pinnedVersion != null
                  ? Caption(project.pinnedVersion)
                  : const Caption('Choose'),
              // const SizedBox(width: 20),
              const Icon(MdiIcons.menuDown),
            ],
          ),
        ),
        onSelected: (version) async {
          context.read(fvmQueueProvider.notifier).pinVersion(project, version);
        },
        itemBuilder: (context) {
          return versions
              .map(
                (version) => PopupMenuItem(
                  value: version.name,
                  child: Text(
                    version.name,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              )
              .toList();
        });
  }
}
