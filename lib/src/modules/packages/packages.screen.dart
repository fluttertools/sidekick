import 'package:flutter/material.dart';
import 'package:sidekick/src/modules/packages/scenes/github_trending.scene.dart';
import 'package:sidekick/src/modules/packages/scenes/used_packages.scene.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          titleSpacing: 0,
          toolbarHeight: 48,
          title: TabBar(
            labelColor: Theme.of(context).textTheme.bodyText1.color,
            labelPadding: EdgeInsets.zero,
            indicatorColor: Theme.of(context).accentColor,
            tabs: [
              Tab(text: '⚡  Trending'),
              Tab(text: '📦  Most Used Packages'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const TrendingSection(),
            const MostUsedScene(),
          ],
        ),
      ),
    );
  }
}
