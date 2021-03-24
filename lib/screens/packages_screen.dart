import 'package:sidekick/components/atoms/list_tile.dart';
import 'package:sidekick/components/atoms/loading_indicator.dart';
import 'package:sidekick/components/atoms/screen.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/components/molecules/github_info_display.dart';
import 'package:sidekick/components/molecules/package_score_display.dart';

import 'package:sidekick/providers/packages.provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:sidekick/utils/open_link.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PackagesScreen extends HookWidget {
  const PackagesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final packages = useProvider(packagesProvider);

    return packages.when(
        data: (data) {
          return FvmScreen(
            title: 'Your Most Popular Packages',
            child: Scrollbar(
              child: ListView.builder(
                // separatorBuilder: (_, __) => const Divider(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final pkg = data[index];
                  final position = ++index;
                  return Container(
                    height: 150,
                    child: Column(
                      children: [
                        FvmListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.black26,
                            child: Text(position.toString()),
                          ),
                          title: Text(pkg.name),
                          subtitle: Text(
                            pkg.description,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          trailing: PackageScoreDisplay(score: pkg.score),
                        ),
                        const Divider(thickness: 0.5),
                        Row(
                          children: [
                            GithubInfoDisplay(
                              repo: pkg.repo,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Caption(pkg.version),
                                      const SizedBox(width: 10),
                                      const Text('·'),
                                      const SizedBox(width: 10),
                                      TextButton(
                                        child: const Text('details'),
                                        onPressed: () async {
                                          await openLink(pkg.url);
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      const Text('·'),
                                      const SizedBox(width: 10),
                                      TextButton(
                                        child: const Text('changelog'),
                                        onPressed: () async {
                                          await openLink(pkg.changelogUrl);
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      const Text('·'),
                                      const SizedBox(width: 10),
                                      TextButton(
                                        child: const Text('website'),
                                        onPressed: () async {
                                          await openLink(pkg.homepage);
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const Divider()
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (_, __) => Container());
  }
}
