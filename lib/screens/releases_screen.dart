import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/components/atoms/screen.dart';
import 'package:sidekick/components/molecules/version_item.dart';
import 'package:sidekick/providers/filterable_versions.provider.dart';
import 'package:sidekick/providers/settings.provider.dart';
import 'package:sidekick/utils/extensions.dart';

class ReleasesScreen extends HookWidget {
  const ReleasesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filter = useProvider(filterProvider);
    final versions = useProvider(filterableVersionsProvider);

    final settings = useProvider(settingsProvider.state);

    return Screen(
      title: 'Flutter Releases',
      actions: [
        DropdownButton<String>(
          value: filter.state.name,
          icon: const Icon(Icons.filter_list),
          underline: Container(),
          items: Filter.values.map((filter) {
            return DropdownMenuItem(
              value: filter.name,
              child: Text(
                filter.name.capitalize(),
              ),
            );
          }).toList(),
          onChanged: (value) {
            filter.state = filterFromName(value);
          },
        ),
      ],
      child: Scrollbar(
        child: ListView.separated(
          itemCount: versions.length,
          separatorBuilder: (_, __) => const Divider(height: 0),
          itemBuilder: (context, index) {
            return VersionItem(versions[index]);
          },
        ),
      ),
    );
  }
}
