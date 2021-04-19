import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/components/atoms/screen.dart';
import 'package:sidekick/components/atoms/sliver_app_bar_switcher.dart';
import 'package:sidekick/components/molecules/version_item.dart';
import 'package:sidekick/providers/filterable_releases.provider.dart';
import 'package:sidekick/providers/settings.provider.dart';
import 'package:sidekick/utils/utils.dart';

import '../components/atoms/screen.dart';
import '../components/atoms/typography.dart';
import '../components/molecules/channel_showcase.dart';
import '../components/molecules/version_install_button.dart';
import '../providers/flutter_releases.provider.dart';

class ReleasesScreen extends HookWidget {
  const ReleasesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filter = useProvider(filterProvider);
    final versions = useProvider(filterableReleasesProvider);
    final releases = useProvider(releasesStateProvider);

    final settings = useProvider(settingsProvider.state);

    return Screen(
      extendBody: false,
      title: 'Releases',
      child: CupertinoScrollbar(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: settings.sidekick.advancedMode ? 80 : 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.deepOrange,
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        const Subheading('Master'),
                        const SizedBox(width: 20),
                        const Expanded(
                          child: Caption(
                            '''The current tip-of-tree, absolute latest cutting edge build.'''
                            '''Usually functional, though sometimes we accidentally break things.''',
                          ),
                        ),
                        const SizedBox(width: 20),
                        VersionInstallButton(releases.master),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 120.0,
              elevation: 1,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              pinned: true,
              excludeHeaderSemantics: true,
              actions: [Container()],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: releases.channels.map((channel) {
                    return Expanded(child: ChannelShowcase(channel));
                  }).toList(),
                ),
              ),
              title: SliverAppBarSwitcher(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: releases.channels.map((channel) {
                      return Expanded(child: VersionItem(channel));
                    }).toList(),
                  ),
                ),
              ),
            ),
            SliverAppBar(
              pinned: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(1),
                child: Divider(height: 0),
              ),
              automaticallyImplyLeading: false,
              // actions: [Container()],
              title: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Heading('Versions'),
                        const SizedBox(width: 10),
                        Chip(label: Text(versions.length.toString())),
                      ],
                    ),
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
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return VersionItem(versions[index]);
              }, childCount: versions.length),
            ),
          ],
        ),
      ),
    );
  }
}
