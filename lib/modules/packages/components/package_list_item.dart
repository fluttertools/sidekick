import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../components/atoms/typography.dart';
import '../../../modules/common/utils/open_link.dart';
import '../../common/molecules/list_tile.dart';
import '../package.dto.dart';
import 'package_github_info.dart';
import 'package_score_display.dart';

/// Package list item
class PackageListItem extends StatelessWidget {
  /// Constructor
  const PackageListItem(
    this.package, {
    Key key,
    this.position,
  }) : super(key: key);

  /// Detail of a package
  final PackageDetail package;

  /// Popular position of package
  final int position;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SkListTile(
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
              PackageGithubInfo(package.repo),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Caption('${package.projectsCount.toString()} projects'),
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
        ],
      ),
    );
  }
}
