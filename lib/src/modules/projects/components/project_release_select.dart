import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../components/atoms/typography.dart';
import '../../../dto/release.dto.dart';
import '../../fvm/fvm_queue.provider.dart';
import '../project.dto.dart';

/// Select project release
class ProjectReleaseSelect extends StatelessWidget {
  /// Constructor
  const ProjectReleaseSelect({
    @required this.project,
    @required this.releases,
    Key key,
  }) : super(key: key);

  /// Project
  final FlutterProject project;

  /// Releases
  final List<ReleaseDto> releases;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
        tooltip: 'Select a Flutter SDK Version',

        // elevation: 1,
        padding: EdgeInsets.zero,
        onSelected: (version) async {
          await context.read(fvmQueueProvider.notifier).pinVersion(project, version);
        },
        itemBuilder: (context) {
          return releases
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
        },
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
        ));
  }
}
