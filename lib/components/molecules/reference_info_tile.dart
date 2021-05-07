import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../dto/channel.dto.dart';
import '../../dto/release.dto.dart';
import '../../modules/common/molecules/list_tile.dart';
import '../../utils/open_link.dart';
import '../atoms/typography.dart';
import 'setup_button.dart';

class ReferenceInfoTile extends StatelessWidget {
  final ReleaseDto version;
  const ReferenceInfoTile(this.version, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Display channell reference if it's a release
    if (!version.isChannel) {
      return Column(
        children: [
          SkListTile(
            title: const Text('Channel'),
            trailing: Chip(label: Text(version.release.channelName)),
          ),
          const Divider(),
          SkListTile(
            title: const Text('Release Notes'),
            trailing: IconButton(
              icon: const Icon(
                Icons.open_in_new,
                size: 20,
              ),
              onPressed: () async {
                await openLink(kFlutterTagsUrl + version.name);
              },
            ),
          ),
        ],
      );
    }

    final channel = version as ChannelDto;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Paragraph(channelDescriptions[version.name]),
        ),
        const Divider(height: 0),
        SkListTile(
          title: const Text('Version'),
          trailing: channel.sdkVersion != null
              ? Chip(label: Text(channel.sdkVersion ?? ''))
              : SetupButton(version: channel),
        )
      ],
    );
  }
}
