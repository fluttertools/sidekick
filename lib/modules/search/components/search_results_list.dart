import 'package:flutter/material.dart';

import '../../common/atoms/sliver_header_delegate.dart';
import '../../common/atoms/sliver_section.dart';
import '../../projects/components/project_list_item.dart';
import '../../releases/components/release_list_item.dart';
import '../search.provider.dart';

/// List of search results
class SearchResultsList extends StatelessWidget {
  /// Constructor
  const SearchResultsList(
    this.results, {
    Key key,
  }) : super(key: key);

  /// Search results
  final SearchResults results;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      constraints: BoxConstraints(
        minHeight: 4,
        maxHeight: MediaQuery.of(context).size.height / 1.2,
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverSection(
            shouldDisplay: results.channels.isNotEmpty,
            slivers: [
              SliverPersistentHeader(
                delegate: SliverHeaderDelegate(
                  title: 'Channels',
                  count: results.channels.length,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ReleaseListItem(results.channels[index]);
                  },
                  childCount: results.channels.length,
                ),
              ),
            ],
          ),
          SliverSection(
            shouldDisplay: results.projects.isNotEmpty,
            slivers: [
              SliverPersistentHeader(
                delegate: SliverHeaderDelegate(
                  title: 'Projects',
                  count: results.projects.length,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return ProjectListItem(results.projects[index]);
                }, childCount: results.projects.length),
              ),
            ],
          ),
          SliverSection(
            shouldDisplay: results.stableReleases.isNotEmpty,
            slivers: [
              SliverPersistentHeader(
                delegate: SliverHeaderDelegate(
                  title: 'Stable Releases',
                  count: results.stableReleases.length,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return ReleaseListItem(results.stableReleases[index]);
                }, childCount: results.stableReleases.length),
              ),
            ],
          ),
          SliverSection(
            shouldDisplay: results.betaReleases.isNotEmpty,
            slivers: [
              SliverPersistentHeader(
                delegate: SliverHeaderDelegate(
                  title: 'Beta Releases',
                  count: results.betaReleases.length,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return ReleaseListItem(results.betaReleases[index]);
                }, childCount: results.betaReleases.length),
              ),
            ],
          ),
          SliverSection(
            shouldDisplay: results.devReleases.isNotEmpty,
            slivers: [
              SliverPersistentHeader(
                delegate: SliverHeaderDelegate(
                  title: 'Dev Releases',
                  count: results.devReleases.length,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return ReleaseListItem(results.devReleases[index]);
                }, childCount: results.devReleases.length),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
