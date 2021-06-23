import 'package:github/github.dart';
import 'package:sidekick/generated/l10n.dart';

/// Sidekick title
const kAppTitle = 'Sidekick';

/// Sidekick app name
const kAppName = 'sidekick';

/// Sidekick bundle id
const kAppBundleId = 'app.fvm.sidekick';

/// Collapsed width
const kNavigationWidth = 65.0;

/// Extended navigation width
const kNavigationWidthExtended = 180.0;

/// Channels without master
const kReleaseChannels = ['stable', 'beta', 'dev'];

/// Master channel
const kMasterChannel = 'master';

/// Github sidekick url
const kGithubSidekickUrl = 'https://github.com/leoafarias/sidekick';

/// Flutter tags
const kFlutterTagsUrl = 'https://github.com/flutter/flutter/releases/tag/';

/// Description for the channels
Map<String, String> channelDescriptions = {
  'stable': S.current.stableChannelDescription,
  'beta': S.current.betaChannelDescription,
  'dev': S.current.devChannelDescription,
  'master': S.current.masterChannelDescription,
};

/// Sidekick repository slug
final kSidekickRepoSlug = RepositorySlug(
  'leoafarias',
  'sidekick',
);
