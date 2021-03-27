import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/components/molecules/version_install_button.dart';
import 'package:sidekick/dto/channel.dto.dart';
import 'package:sidekick/providers/selected_info_provider.dart';

import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/utils/layout_size.dart';

class ChannelShowcase extends StatelessWidget {
  final ChannelDto channel;
  const ChannelShowcase(this.channel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            left: BorderSide(color: Theme.of(context).dividerColor),
            bottom: BorderSide(color: Theme.of(context).dividerColor),
            top: BorderSide(color: Theme.of(context).dividerColor),
            // TODO: quite a hacky way to achieve this
            right: channel.name == "dev"
                ? BorderSide(color: Theme.of(context).dividerColor)
                : BorderSide.none),
      ),
      child: OutlinedButton(
        onPressed: () {
          context.read(selectedInfoProvider).selectVersion(channel);
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith(
            (states) => const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          side: MaterialStateProperty.resolveWith((states) => BorderSide.none),
        ),
        child: LayoutBuilder(builder: (context, layout) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Heading(channel.name),
                    Tooltip(
                      message: channel.release.version,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 65),
                        child: Text(
                          channel.release.version,
                          style: Theme.of(context).textTheme.subtitle1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Caption(
                      DateTimeFormat.relative(
                        channel.release.releaseDate,
                        appendIfAfter: 'ago',
                      ),
                    ),
                  ],
                ),
                LayoutSize.isSmall ? Container() : const Spacer(),
                LayoutSize.isSmall
                    ? Container()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          VersionInstallButton(channel),
                        ],
                      )
              ],
            ),
          );
        }),
      ),
    );
  }
}
