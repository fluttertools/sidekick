import 'package:flutter/material.dart';
import 'package:i18next/i18next.dart';

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

const kSidekickLatestReleaseUrl =
    'https://api.github.com/repos/leoafarias/sidekick/releases/latest';

/// Flutter tags
const kFlutterTagsUrl = 'https://github.com/flutter/flutter/releases/tag/';

/// Description for the channels
Map<String, String> channelDescriptions(BuildContext context) => {
      'stable':
          I18Next.of(context).t('modules:common.stableChannelDescription'),
      'beta': I18Next.of(context).t('modules:common.betaChannelDescription'),
      'dev': I18Next.of(context).t('modules:common.devChannelDescription'),
      'master':
          I18Next.of(context).t('modules:common.masterChannelDescription'),
    };
