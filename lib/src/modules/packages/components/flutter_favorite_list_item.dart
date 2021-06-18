import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/src/modules/common/utils/open_link.dart';
import 'package:sidekick/src/modules/packages/flutter_favorite.dto.dart';

import '../../common/molecules/list_tile.dart';

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
          trailing: OutlinedButton(
            onPressed: () => openLink(package.url),
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
