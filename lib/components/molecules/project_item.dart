import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/components/atoms/local_link_button.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/components/molecules/project_version_select.dart';
import 'package:sidekick/components/molecules/version_install_button.dart';
import 'package:sidekick/dto/project.dto.dart';
import 'package:sidekick/providers/flutter_releases.provider.dart';
import 'package:sidekick/screens/playground_screen.dart';

class ProjectItem extends HookWidget {
  final FlutterProject project;

  /// Show version selector
  final bool versionSelect;
  const ProjectItem(
    this.project, {
    this.versionSelect = false,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cachedVersions = useProvider(releasesStateProvider).allCached;

    final version = useProvider(getVersionProvider(project.pinnedVersion));

    final needInstall = version != null && project.pinnedVersion != null;

    void openProjectPlayground() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlaygroundScreen(
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
                  trailing: Tooltip(
                    message: "Open terminal playground",
                    child: IconButton(
                      iconSize: 20,
                      splashRadius: 20,
                      icon: const Icon(MdiIcons.consoleLine),
                      onPressed: openProjectPlayground,
                    ),
                  ),
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
                  LocalLinkButton(project.projectDir.absolute.path),
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
                            ProjectVersionSelect(
                              project: project,
                              versions: cachedVersions ?? [],
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
