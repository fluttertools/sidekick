import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../components/atoms/typography.dart';
import '../../utils/notify.dart';
import '../common/atoms/checkbox.dart';
import '../common/atoms/refresh_button.dart';
import '../common/organisms/screen.dart';
import '../settings/settings.provider.dart';
import 'components/project_list_item.dart';
import 'components/projects_empty.dart';
import 'projects.provider.dart';

/// Projects screen
class ProjectsScreen extends HookWidget {
  /// Constructor
  const ProjectsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projects = useProvider(projectsProvider);
    final filteredProjects = useState(projects);

    final settings = useProvider(settingsProvider);
    Future<void> onRefresh() async {
      await context.read(projectsProvider.notifier).load();
      notify('Projects Refreshed');
    }

    useEffect(() {
      if (settings.sidekick.onlyProjectsWithFvm) {
        filteredProjects.value =
            projects.where((p) => p.pinnedVersion != null).toList();
      } else {
        filteredProjects.value = [...projects];
      }
      return;
    }, [projects, settings.sidekick]);

    if (projects.isEmpty && filteredProjects.value.isEmpty) {
      return const EmptyProjects();
    }

    return SkScreen(
      title: 'Projects',
      actions: [
        Caption('${projects.length} Projects'),
        const SizedBox(width: 10),
        Tooltip(
          message: 'Only display projects that have versions pinned',
          child: SkCheckBox(
            label: 'FVM Only',
            value: settings.sidekick.onlyProjectsWithFvm,
            onChanged: (value) {
              settings.sidekick.onlyProjectsWithFvm = value;
              context.read(settingsProvider.notifier).save(settings);
            },
          ),
        ),
        const SizedBox(width: 10),
        RefreshButton(
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
                  child: ProjectListItem(
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
