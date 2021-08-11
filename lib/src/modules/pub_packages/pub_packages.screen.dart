import 'package:flutter/material.dart';
import 'package:i18next/i18next.dart';
import 'package:sidekick/src/modules/pub_packages/scenes/flutter_favorite.scene.dart';
import 'package:sidekick/src/modules/pub_packages/scenes/github_trending.scene.dart';
import 'package:sidekick/src/modules/pub_packages/scenes/used_packages.scene.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          titleSpacing: 0,
          toolbarHeight: 48,
          title: TabBar(
            labelColor: Theme.of(context).textTheme.bodyText1.color,
            labelPadding: EdgeInsets.zero,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            tabs: [
              Tab(
                  text:
                      '⚡   ${I18Next.of(context).t('modules:pubPackages.trending')}'),
              Tab(
                  text:
                      '📦   ${I18Next.of(context).t('modules:pubPackages.mostUsedPackages')}'),
              Tab(
                  text:
                      '💙   ${I18Next.of(context).t('modules:pubPackages.flutterFavorites')}'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const TrendingSection(),
            const MostUsedScene(),
            const FlutterFavoriteScene(),
          ],
        ),
      ),
    );
  }
}
