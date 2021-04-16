const kNavigationWidth = 65.0;
const kNavigationWidthExtended = 180.0;
const kReleaseChannels = ['stable', 'beta', 'dev'];
const kMasterChannel = 'master';
const kGithubSidekickUrl = 'https://github.com/leoafarias/sidekick';

const kFlutterTagsUrl = 'https://github.com/flutter/flutter/releases/tag/';

Map<String, String> channelDescriptions = {
  'stable':
      '''We recommend that you use this channel for all production app releases. Roughly once a quarter, a branch that has been stabilized on beta will become our next stable branch and we will create a stable release from that branch.''',
  'beta':
      '''Branch created from master for a new beta release at the beginning of the month, usually the first Monday. This will include a branch for Dart, the Engine and the Framework.''',
  'dev':
      '''The latest fully-tested build. Usually functional, but see Bad Builds for a list of known "bad" dev builds.''',
  'master':
      '''The current tip-of-tree, absolute latest cutting edge build. Usually functional, though sometimes we accidentally break things.''',
};
