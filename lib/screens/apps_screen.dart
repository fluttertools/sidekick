import 'package:sidekick/components/atoms/loading_indicator.dart';
import 'package:sidekick/components/atoms/screen.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/providers/settings.provider.dart';
import 'package:sidekick/utils/notify.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:sidekick/components/molecules/empty_data_set/empty_projects.dart';
import 'package:sidekick/components/molecules/project_item.dart';
import 'package:sidekick/providers/projects_provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

class AppsScreen extends HookWidget {
  const AppsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projects = useProvider(projectsProvider.state);
    final filteredProjects = useState(projects.list);
    final settings = useProvider(settingsProvider.state);

    useEffect(() {
      if (settings.onlyProjectsWithFvm) {
        filteredProjects.value =
            projects.list.where((p) => p.pinnedVersion != null).toList();
      } else {
        filteredProjects.value = projects.list;
      }
      return;
    }, [projects, settings.onlyProjectsWithFvm]);

    if (projects.loading) {
      return const Center(
        child: LoadingIndicator(),
      );
    }

    if (filteredProjects.value.isEmpty) {
      return const EmptyProjects();
    }

    return FvmScreen(
      title: 'Apps',
      actions: [
        TextButton.icon(
          label: const Caption('Refresh'),
          icon: const Icon(MdiIcons.refresh, size: 20),
          onPressed: () async {
            await context.read(projectsProvider).scan();
            notify('Apps Refreshed');
          },
        ),
        const VerticalDivider(
          width: 40,
        ),
        Tooltip(
          message: '''Displays only projects with versions pinned.''',
          child: Row(
            children: [
              const Caption('Only Pinned'),
              SizedBox(
                height: 10,
                width: 60,
                child: Switch(
                  activeColor: Colors.cyan,
                  value: settings.onlyProjectsWithFvm,
                  onChanged: (active) async {
                    settings.onlyProjectsWithFvm = active;
                    await context.read(settingsProvider).save(settings);
                  },
                ),
              ),
            ],
          ),
        )
      ],
      child: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ResponsiveGridList(
              desiredItemWidth: 250,
              minSpacing: 10,
              children: filteredProjects.value.map((project) {
                return ProjectItem(project, key: Key(project.projectDir.path));
              }).toList()),
        ),
      ),
    );
  }
}
