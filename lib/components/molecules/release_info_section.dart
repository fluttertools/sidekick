import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';

import '../../dto/release.dto.dart';
import '../../modules/common/molecules/list_tile.dart';
import 'advanced_info_tile.dart';

class ReleaseInfoSection extends StatelessWidget {
  final ReleaseDto version;
  const ReleaseInfoSection(this.version, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (version.release == null) {
      return const SizedBox(height: 0);
    }

    return Column(
      children: [
        SkListTile(
          title: const Text('Release Date'),
          trailing: Text(DateTimeFormat.format(
            version.release.releaseDate,
            format: AmericanDateFormats.abbr,
          )),
        ),
        AdvancedInfoTile(version),
      ],
    );
  }
}
