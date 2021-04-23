import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/dto/release.dto.dart';

class CacheVersionSelect extends StatelessWidget {
  final List<ReleaseDto> versions;
  final Function(String) onSelect;

  const CacheVersionSelect({
    @required this.versions,
    @required this.onSelect,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopupMenuButton<String>(
          tooltip: 'Select a Flutter SDK Version',

          // elevation: 1,
          padding: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
            // color: Colors.black38,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.white12)),
            constraints: const BoxConstraints(
              maxWidth: 165,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Caption('Choose'),
                //  SizedBox(width: 20),
                Icon(MdiIcons.menuDown),
              ],
            ),
          ),
          onSelected: onSelect,
          itemBuilder: (context) {
            return versions
                .map(
                  (version) => PopupMenuItem(
                    value: version.name,
                    child: Text(
                      version.name,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                )
                .toList();
          }),
    );
  }
}
