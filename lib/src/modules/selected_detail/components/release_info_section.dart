import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:i18next/i18next.dart';

import '../../../components/molecules/list_tile.dart';
import '../../common/dto/release.dto.dart';
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
          title: Text(I18Next.of(context)
              .t('modules:selectedDetail.components.releaseDate')),
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
