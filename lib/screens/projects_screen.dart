import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:sidekick/components/atoms/checkbox.dart';
import 'package:sidekick/components/atoms/refresh_button.dart';
import 'package:sidekick/components/atoms/screen.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/components/molecules/empty_data_set/empty_projects.dart';
import 'package:sidekick/components/molecules/project_item.dart';
import 'package:sidekick/providers/projects_provider.dart';
import 'package:sidekick/providers/settings.provider.dart';
import 'package:sidekick/utils/notify.dart';

class ProjectsScreen extends HookWidget {
  const ProjectsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projects = useProvider(projectsProvider.state);
    final filteredProjects = useState(projects.list);

    final settings = useProvider(settingsProvider.state);
    void onRefresh() async {
      await context.read(projectsProvider).reloadAll(withDelay: true);
      notify('Projects Refreshed');
    }

    useEffect(() {
      if (settings.sidekick.onlyProjectsWithFvm) {
        filteredProjects.value =
            projects.list.where((p) => p.pinnedVersion != null).toList();
      } else {
        filteredProjects.value = [...projects.list];
      }
      return;
    }, [projects.list, settings.sidekick]);

    if (filteredProjects.value.isEmpty && !projects.loading) {
      return EmptyProjects(
        onRetry: onRefresh,
      );
    }

    return Screen(
      title: 'Projects',
      processing: projects.loading,
      actions: [
        Caption('${filteredProjects.value.length} Projects'),
        const SizedBox(width: 10),
        Tooltip(
          message: 'Only display projects that have versions pinned',
          child: CheckButton(
            label: 'Pinned',
            value: settings.sidekick.onlyProjectsWithFvm,
            onChanged: (value) {
              settings.sidekick.onlyProjectsWithFvm = value;
              context.read(settingsProvider).save(settings);
            },
          ),
        ),
        const SizedBox(width: 10),
        RefreshButton(
          refreshing: projects.loading,
          onPressed: onRefresh,
        ),
      ],
      child: CupertinoScrollbar(
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: ResponsiveGridList(
              desiredItemWidth: 290,
              minSpacing: 0,
              children: filteredProjects.value.map((project) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: ProjectItem(
                    project,
                    versionSelect: true,
                    key: Key(project.projectDir.path),
                  ),
                );
              }).toList()),
        ),
      ),
    );
  }
}
