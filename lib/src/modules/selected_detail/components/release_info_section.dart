import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';

import '../../../components/molecules/list_tile.dart';
import '../../common/dto/release.dto.dart';
import '../../common/utils/helpers.dart';
import 'advanced_info_tile.dart';

class ReleaseInfoSection extends StatelessWidget {
  final ReleaseDto version;
  const ReleaseInfoSection(
    this.version, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final releaseDate = version.release?.releaseDate;
    if (version.release == null || releaseDate == null) {
      return const SizedBox(height: 0);
    }

    return Column(
      children: [
        SkListTile(
          title: Text(
              context.i18n('modules:selectedDetail.components.releaseDate')),
          trailing: Text(DateTimeFormat.format(
            releaseDate,
            format: AmericanDateFormats.abbr,
          )),
        ),
        AdvancedInfoTile(version),
      ],
    );
  }
}
