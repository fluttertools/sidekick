import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:sidekick/components/atoms/loading_indicator.dart';
import 'package:sidekick/components/atoms/screen.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/components/molecules/empty_data_set/empty_projects.dart';
import 'package:sidekick/components/molecules/project_item.dart';
import 'package:sidekick/providers/flutter_projects_provider.dart';
import 'package:sidekick/providers/settings.provider.dart';
import 'package:sidekick/utils/notify.dart';

class ProjectsScreen extends HookWidget {
  const ProjectsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projects = useProvider(projectsProvider.state);
    final filteredProjects = useState(projects.list);
    final settings = useProvider(settingsProvider.state);

    final appSettings = settings.sidekick;

    useEffect(() {
      if (appSettings.onlyProjectsWithFvm) {
        filteredProjects.value =
            projects.list.where((p) => p.pinnedVersion != null).toList();
      } else {
        filteredProjects.value = [...projects.list];
      }
      return;
    }, [projects.list]);

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
      ],
      child: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ResponsiveGridList(
              desiredItemWidth: 290,
              minSpacing: 10,
              children: filteredProjects.value.map((project) {
                return ProjectItem(project, key: Key(project.projectDir.path));
              }).toList()),
        ),
      ),
    );
  }
}
