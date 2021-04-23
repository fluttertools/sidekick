import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/components/atoms/list_tile.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/components/molecules/github_repo_info.dart';
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
              child: Text(
                position.toString(),
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
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
              GithubRepoInfo(package.repo),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Caption('${package.count.toString()} projects'),
                        const SizedBox(width: 10),
                        const Text('·'),
                        const SizedBox(width: 10),
                        Caption(package.version),
                        const SizedBox(width: 10),
                        const Text('·'),
                        const SizedBox(width: 10),
                        Tooltip(
                          message: 'Details',
                          child: IconButton(
                            iconSize: 20,
                            splashRadius: 20,
                            icon: const Icon(MdiIcons.informationOutline),
                            onPressed: () async {
                              await openLink(package.url);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('·'),
                        const SizedBox(width: 10),
                        Tooltip(
                          message: 'Changelog',
                          child: IconButton(
                            iconSize: 20,
                            splashRadius: 20,
                            icon: const Icon(MdiIcons.textBox),
                            onPressed: () async {
                              await openLink(package.changelogUrl);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('·'),
                        const SizedBox(width: 10),
                        Tooltip(
                          message: 'Website',
                          child: IconButton(
                            iconSize: 20,
                            splashRadius: 20,
                            icon: const Icon(MdiIcons.earth),
                            onPressed: () async {
                              await openLink(package.homepage);
                            },
                          ),
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
