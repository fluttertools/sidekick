import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../components/atoms/typography.dart';
import '../../../components/molecules/version_install_button.dart';
import '../../../modules/common/dto/channel.dto.dart';
import '../../selected_detail/selected_detail.provider.dart';

/// Channel showcase widget
class ChannelShowcaseItem extends ConsumerWidget {
  /// Constructor
  const ChannelShowcaseItem(
    this.channel, {
    Key? key,
  }) : super(key: key);

  /// Channel
  final ChannelDto channel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final releaseDate = channel.release?.releaseDate;
    return Card(
      child: InkWell(
        onTap: () {
          ref.read(selectedDetailProvider.notifier).state = SelectedDetail(
            release: channel,
          );
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
                  Subheading(channel.release?.version ?? ''),
                  const SizedBox(height: 5),
                  Caption(
                    releaseDate != null
                        ? DateTimeFormat.relative(
                            releaseDate,
                            appendIfAfter: 'ago',
                          )
                        : '',
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
      ),
    );
  }
}
