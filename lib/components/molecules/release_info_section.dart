import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:sidekick/components/atoms/list_tile.dart';
import 'package:sidekick/components/molecules/advanced_info_tile.dart';
import 'package:sidekick/dto/version.dto.dart';

class ReleaseInfoSection extends StatelessWidget {
  final VersionDto version;
  const ReleaseInfoSection(this.version, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (version.release == null) {
      return const SizedBox(height: 0);
    }

    return Column(
      children: [
        FvmListTile(
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
