import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sidekick/src/modules/../components/atoms/empty_dataset.dart';
import 'package:sidekick/src/modules/common/utils/open_link.dart';
import 'package:sidekick/src/window_border.dart';
import 'package:window_manager/window_manager.dart';

class ErrorDBScreen extends StatelessWidget {
  const ErrorDBScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    EmptyDataset(
                      icon: const Icon(Icons.error_outline_outlined),
                      iconColor: Theme.of(context).colorScheme.error,
                      opacity: 1,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      'There was an issue opening Sidekick',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      text,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton.icon(
                          style: ButtonStyle(
                              padding: WidgetStateProperty.resolveWith(
                                  (states) => const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10))),
                          onPressed: () {
                            openLink(
                                'https://github.com/leoafarias/sidekick/issues/new/choose');
                          },
                          label: const Text('Create new issue'),
                          icon: const Icon(
                            Icons.open_in_new,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                          label: const Text('Close'),
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            exit(0);
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTapDown: (_) {
                        windowManager.startDragging();
                      },
                    ),
                  ),
                  const WindowButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const text = 'Sidekick is having trouble reading its settings.\n'
    'Please make sure that there are no other instances of Sidekick running\n'
    'and try again. If the problem persists, please open a Github Issue.';
