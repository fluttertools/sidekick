import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';
import 'package:sidekick/src/modules/common/utils/open_link.dart';
import 'package:sidekick/src/modules/packages/trending_package.dto.dart';

import '../../../components/atoms/typography.dart';
import '../../common/molecules/list_tile.dart';

/// Trending package list item
class TrendingGithubRepoItem extends StatelessWidget {
  /// Constructor
  const TrendingGithubRepoItem(
    this.package, {
    Key key,
    this.position,
  }) : super(key: key);

  /// Detail of a package
  final TrendingPackage package;

  /// Popular position of package
  final int position;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SkListTile(
          title: Text('${package.owner}/${package.repoName}'),
          trailing: OutlinedButton(
            onPressed: () => openLink(
              'https://github.com/${package.owner}/${package.repoName}',
            ),
            child: const Text('View'),
          ),
          subtitle: Text(
            package.description,
            maxLines: 2,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Container(
          height: 55,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 20),
                    Icon(MdiIcons.star, size: 15),
                    SizedBox(width: 5),
                    Caption(numberFormatter.format(package.totalStars)),
                    SizedBox(width: 20),
                    Icon(MdiIcons.sourceBranch, size: 15),
                    SizedBox(width: 5),
                    Caption(numberFormatter.format(package.totalForks)),
                    SizedBox(width: 20),
                    Caption('Built by '),
                    ...package.topContributors
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(e.avatar),
                            ),
                          ),
                        )
                        .toList(),
                    Spacer(),
                    Caption(package.starsSince),
                    SizedBox(width: 20)
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
