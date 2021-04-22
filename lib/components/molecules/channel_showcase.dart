import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/components/molecules/version_install_button.dart';
import 'package:sidekick/dto/channel.dto.dart';
import 'package:sidekick/providers/selected_info_provider.dart';

class ChannelShowcase extends StatelessWidget {
  final ChannelDto channel;
  const ChannelShowcase(this.channel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        context.read(selectedInfoProvider.notifier).selectVersion(channel);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Heading(channel.name),
                Subheading(channel.release.version),
                const SizedBox(height: 5),
                Caption(
                  DateTimeFormat.relative(
                    channel.release.releaseDate,
                    appendIfAfter: 'ago',
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                VersionInstallButton(channel),
              ],
            )
          ],
        ),
      ),
    );
  }
}
