import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../dto/channel.dto.dart';
import '../dto/version.dto.dart';
import '../modules/flutter_releases/flutter_releases.provider.dart';
import '../modules/projects/projects.provider.dart';

enum SearchResultGroup { channel, project, stable, beta, dev }

class SearchResults {
  final List<Project> projects;
  final List<ChannelDto> channels;
  // Releases
  final List<VersionDto> stableReleases;
  final List<VersionDto> betaReleases;
  final List<VersionDto> devReleases;

  SearchResults({
    this.projects = const [],
    this.channels = const [],
    this.stableReleases = const [],
    this.betaReleases = const [],
    this.devReleases = const [],
  });

  bool get isEmpty {
    return projects.isEmpty &&
        channels.isEmpty &&
        stableReleases.isEmpty &&
        betaReleases.isEmpty &&
        devReleases.isEmpty;
  }
}

final searchQueryProvider = StateProvider<String>((_) => '');

// ignore: top_level_function_literal_block
final searchResultsProvider = Provider((ref) {
  final query = ref.watch(searchQueryProvider).state;
  final releaseState = ref.read(releasesStateProvider);

  final projects = ref.read(projectsProvider);

  // If projects is not fetched or there is no query return empty results
  if (projects == null || query == null) {
    return SearchResults();
  }

  // Split query into multiple search terms
  final searchTerms = query.toLowerCase().split(' ');

  final projectResults = <Project>[];
  final channelResults = <ChannelDto>[];
  final stableReleaseResults = <VersionDto>[];
  final betaReleaseResults = <VersionDto>[];
  final devReleaseResults = <VersionDto>[];

  // We look for multiple terms, make sure result only shows up once
  final uniques = <String, bool>{};

  for (final term in searchTerms) {
    // Skip if term is empty space
    if (term.isEmpty) {
      break;
    }
    // Loop projects
    for (final project in projects.list) {
      // Limit results to only 5 projects
      if (projectResults.length >= 5) {
        break;
      }

      // Limit to only unique results even if it matches in multiple terms
      // If already exists skip
      if (uniques[project.name] == true) break;

      // Get projec pinnedVersion
      final pinnedVersion = project.pinnedVersion ?? '';
      // Add project if name or pinnedVersion start with term
      if (project.name.toLowerCase().startsWith(term) ||
          pinnedVersion.startsWith(term)) {
        // Add to track unique insertions
        uniques[project.name] = true;

        projectResults.add(project);
      }
    }

    // Look through the releases to see if
    // query matches release names
    for (final release in releaseState.versions) {
      // Get channel name to pass to map
      final channelName = release.release.channelName;

      // Only unique results
      if (uniques[release.name] == true) break;

      // Match result that name or channel name starts with term
      if (release.name.startsWith(term) || channelName.startsWith(term)) {
        // Track unique insertions
        uniques[release.name] = true;

        // Map releases to channel groups
        // TODO: remove this logic and use filterable
        switch (release.release.channel) {
          case Channel.stable:
            stableReleaseResults.add(release);
            break;
          case Channel.beta:
            betaReleaseResults.add(release);
            break;
          case Channel.dev:
            devReleaseResults.add(release);
            break;
          default:
            throw Exception('Invalid chanel');
        }
      }
    }

    //Loop channels
    for (final channel in releaseState.channels) {
      // Only unique results
      if (uniques[channel.name] == true) break;

      // Match if channel name starts with term
      if (channel.name.startsWith(term)) {
        // Track unique insertions
        uniques[channel.name] = true;

        // Add to channel results
        channelResults.add(channel);
      }
    }
  }
  ;

  return SearchResults(
    channels: channelResults,
    projects: projectResults,
    stableReleases: stableReleaseResults,
    betaReleases: betaReleaseResults,
    devReleases: devReleaseResults,
  );
});
