import 'package:flutter/rendering.dart';
import 'package:sidekick/components/atoms/list_tile.dart';
import 'package:sidekick/components/atoms/typography.dart';

import 'package:flutter/material.dart';
import 'package:sidekick/components/molecules/github_info_display.dart';
import 'package:sidekick/components/molecules/package_score_display.dart';
import 'package:sidekick/dto/package_detail.dto.dart';
import 'package:sidekick/utils/open_link.dart';

class PackageItem extends StatelessWidget {
  final PackageDetail package;
  final int position;
  const PackageItem(this.package, {Key key, this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Column(
        children: [
          FvmListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black26,
              child: Text(position.toString()),
            ),
            title: Text(package.name),
            subtitle: Text(
              package.description,
              maxLines: 2,
              style: Theme.of(context).textTheme.caption,
            ),
            trailing: PackageScoreDisplay(score: package.score),
          ),
          const Divider(thickness: 0.5),
          Row(
            children: [
              GithubInfoDisplay(
                repo: package.repo,
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Caption(package.version),
                        const SizedBox(width: 10),
                        const Text('·'),
                        const SizedBox(width: 10),
                        TextButton(
                          child: const Text('details'),
                          onPressed: () async {
                            await openLink(package.url);
                          },
                        ),
                        const SizedBox(width: 10),
                        const Text('·'),
                        const SizedBox(width: 10),
                        TextButton(
                          child: const Text('changelog'),
                          onPressed: () async {
                            await openLink(package.changelogUrl);
                          },
                        ),
                        const SizedBox(width: 10),
                        const Text('·'),
                        const SizedBox(width: 10),
                        TextButton(
                          child: const Text('website'),
                          onPressed: () async {
                            await openLink(package.homepage);
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
  }
}
