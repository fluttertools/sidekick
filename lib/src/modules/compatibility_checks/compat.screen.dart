import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/src/components/atoms/typography.dart';
import 'package:sidekick/src/components/molecules/top_app_bar.dart';
import 'package:sidekick/src/modules/common/app_shell.dart';
import 'package:sidekick/src/modules/common/utils/notify.dart';
import 'package:sidekick/src/modules/common/utils/open_link.dart';
import 'package:sidekick/src/modules/compatibility_checks/compat.provider.dart';
import 'package:sidekick/src/modules/compatibility_checks/compat.service.dart';
import 'package:sidekick/src/modules/compatibility_checks/dialogs/choco.compat.dialog.dart';

import '../../theme.dart';
import 'compat.utils.dart';
import 'dialogs/brew.compat.dialog.dart';

/// Settings screen
class CompatCheckScreen extends HookWidget {
  /// Constructor
  const CompatCheckScreen({
    key,
  }) : super(key: key);

  /// Current nav section
  @override
  Widget build(BuildContext context) {
    var provider = useProvider(compatProvider);
    var providerState = useProvider(compatProvider.notifier);

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
                const Heading(
                    "Sidekick failed to detect one or more necessary components"),
                const SizedBox(
                  height: 5,
                ),
                const Subheading(
                    "This is the breakdown of what is and is not missing:"),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
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
                          const Subheading(
                              "Git is used to download and update flutter versions. It is utilized by FVM"),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Heading("FVM"),
                              Icon(provider.fvm
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.error_outline_rounded)
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Subheading(
                              "Flutter Version Management. Provides Sidekick with most of its core functionality."),
                          const SizedBox(
                            height: 15,
                          ),
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
                          const SizedBox(
                            height: 5,
                          ),
                          const Subheading(
                              "Optional. May be used to install FVM if it is not present on Windows devices."),
                          const SizedBox(
                            height: 15,
                          ),
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
                          const Subheading(
                              "Optional. May be used to install FVM if it is not present on MacOS and Linux devices."),
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
                    const Subheading(
                        "Please install the missing components in order to use Sidekick!"),
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
                          child: const Text("Ignore"),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (Platform.isMacOS) {
                              if (!provider.brew) {
                                showDialog(
                                  context: context,
                                  builder: (context) => BrewDialog(),
                                );
                                return;
                              }
                            } else if (Platform.isWindows) {
                              if (provider.choco) {
                                showDialog(
                                  context: context,
                                  builder: (context) => ChocoDialog(),
                                );
                                return;
                              }
                            }
                          },
                          child: const Text("Install Missing"),
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
