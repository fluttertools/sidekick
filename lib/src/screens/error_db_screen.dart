import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sidekick/src/modules/../components/atoms/empty_dataset.dart';
import 'package:sidekick/src/modules/common/utils/open_link.dart';

class ErrorDBScreen extends StatelessWidget {
  const ErrorDBScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  EmptyDataset(
                    icon: Icon(Icons.error_outline_outlined),
                    iconColor: Theme.of(context).errorColor,
                    opacity: 1,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'There was an isssue opening Sidekick',
                    style: Theme.of(context).textTheme.headline4,
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
                            padding: MaterialStateProperty.resolveWith(
                                (states) => EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10))),
                        onPressed: () {
                          openLink(
                              'https://github.com/leoafarias/sidekick/issues/new/choose');
                        },
                        label: Text('Create new issue'),
                        icon: Icon(
                          Icons.open_in_new,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton.icon(
                        label: Text('Close'),
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          exit(0);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const text = 'Sidekick is having trouble reading its settings.\n'
    'Please make sure that there are no other instances of Sidekick running\n'
    'and try again. If the problem persists, please open a Github Issue.';
