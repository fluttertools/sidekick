import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../components/atoms/typography.dart';
import '../../../components/molecules/version_install_button.dart';
import '../../releases/releases.provider.dart';
import '../../sandbox/sandbox.screen.dart';
import '../project.dto.dart';
import 'project_actions.dart';
import 'project_release_select.dart';

/// Project list item
class ProjectListItem extends HookWidget {
  /// Constructor
  const ProjectListItem(
    this.project, {
    this.versionSelect = false,
    key,
  }) : super(key: key);

  /// Flutter project
  final FlutterProject project;

  /// Show version selector
  final bool versionSelect;

  @override
  Widget build(BuildContext context) {
    final cachedVersions = useProvider(releasesStateProvider).all;

    final version = useProvider(getVersionProvider(project.pinnedVersion));

    final needInstall = version != null && project.pinnedVersion != null;

    void openProjectPlayground() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SandboxScreen(
            project: project,
          ),
        ),
      );
    }

    return Container(
      height: 170,
      child: Center(
        child: Card(
          child: Column(
            children: [
              Container(
                child: ListTile(
                  leading: const Icon(MdiIcons.alphaPBox),
                  title: Subheading(project.name),
                  trailing: ProjectActions(project),
                ),
              ),
              const Divider(height: 0, thickness: 1),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          Paragraph(
                            project.description,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Divider(thickness: 1, height: 0),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Tooltip(
                    message: 'Open terminal playground',
                    child: IconButton(
                      iconSize: 20,
                      splashRadius: 20,
                      icon: const Icon(MdiIcons.consoleLine),
                      onPressed: openProjectPlayground,
                    ),
                  ),
                  const Spacer(),
                  versionSelect
                      ? Row(
                          children: [
                            needInstall
                                ? VersionInstallButton(version,
                                    warningIcon: true)
                                : const SizedBox(
                                    height: 0,
                                    width: 0,
                                  ),
                            ProjectReleaseSelect(
                              project: project,
                              releases: cachedVersions ?? [],
                            )
                          ],
                        )
                      : Container(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
