import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';

import '../../common/dto/release.dto.dart';
import '../fvm_queue.provider.dart';

/// Setup button
class SetupButton extends ConsumerWidget {
  /// Constructor
  const SetupButton({
    required this.release,
    Key? key,
  }) : super(key: key);

  /// Release
  final ReleaseDto release;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: context.i18n('modules:fvm.components.sdkHasNotFinishedSetup'),
      child: IconButton(
        icon: const Icon(MdiIcons.alert),
        iconSize: 20,
        splashRadius: 20,
        color: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          ref.read(fvmQueueProvider.notifier).setup(context, release);
        },
      ),
    );
  }
}
