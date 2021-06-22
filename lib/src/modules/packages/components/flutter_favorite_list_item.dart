import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/generated/l10n.dart';
import 'package:sidekick/src/modules/packages/flutter_favorite.dto.dart';

import '../../../components/atoms/typography.dart';
import '../../../modules/common/utils/open_link.dart';
import '../../common/molecules/list_tile.dart';
import 'package_score_display.dart';

/// Flutter favorite list item
class FlutterFavoriteListItem extends StatelessWidget {
  /// Constructor
  const FlutterFavoriteListItem(
    this.package, {
    Key key,
    this.position,
  }) : super(key: key);

  /// Detail of a package
  final FlutterFavorite package;

  /// Popular position of package
  final int position;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SkListTile(
          title: Text(package.name),
          subtitle: Text(
            package.description,
            maxLines: 2,
            style: Theme.of(context).textTheme.caption,
          ),
          trailing: PackageScoreDisplay(score: package.score),
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  Caption(package.version),
                  Spacer(),
                  Tooltip(
                    message: S.of(context).details,
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
                    message: S.of(context).changelog,
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
                    message: S.of(context).website,
                    child: IconButton(
                      iconSize: 20,
                      splashRadius: 20,
                      icon: const Icon(MdiIcons.earth),
                      onPressed: () async {
                        await openLink(package.url);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
