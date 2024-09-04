import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/src/components/atoms/typography.dart';
import 'package:sidekick/src/components/molecules/top_app_bar.dart';
import 'package:sidekick/src/modules/common/app_shell.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';
import 'package:sidekick/src/modules/compatibility_checks/compat.provider.dart';

import '../../theme.dart';
import 'compat.dialog.dart';

/// Settings screen
class CompatCheckScreen extends ConsumerWidget {
  /// Constructor
  const CompatCheckScreen({
    super.key,
  });

  /// Current nav section
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(compatProvider);
    var providerState = ref.watch(compatProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: false,
      extendBody: true,
      appBar: const SkAppBar(),
      backgroundColor: platformBackgroundColor(context),
      body: Center(
        //padding: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800, maxHeight: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Heading(context.i18n('modules:compatibility.screen.title')),
                const SizedBox(
                  height: 5,
                ),
                Subheading(
                    context.i18n('modules:compatibility.screen.subtitle')),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Heading("Git"),
                              Icon(provider.git
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.error_outline_rounded)
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Subheading(context.i18n(
                              'modules:compatibility.screen.gitDescription')),
                          const SizedBox(
                            height: 15,
                          ),
                          if (Platform.isWindows)
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Heading("Chocolatey"),
                                Icon(provider.choco
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.error_outline_rounded)
                              ],
                            ),
                          if (Platform.isLinux || Platform.isMacOS)
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Heading("Brew"),
                                Icon(provider.brew
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.error_outline_rounded)
                              ],
                            ),
                          const SizedBox(
                            height: 5,
                          ),
                          if (Platform.isWindows)
                            Subheading(context.i18n(
                                'modules:compatibility.screen.chocoDescription')),
                          if (Platform.isLinux || Platform.isMacOS)
                            Subheading(context.i18n(
                                'modules:compatibility.screen.brewDescription')),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Subheading(context
                          .i18n('modules:compatibility.screen.pleaseInstall')),
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            providerState.applyValid();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AppShell(),
                              ),
                            );
                          },
                          child: Text(context
                              .i18n('modules:compatibility.screen.ignore')),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const CompatDialog(),
                            );
                          },
                          child: Text(context.i18n(
                              'modules:compatibility.screen.installmissing')),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
