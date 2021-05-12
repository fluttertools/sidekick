import 'dart:io';

import 'package:flutter/material.dart';

class ErrorDBScreen extends StatelessWidget {
  const ErrorDBScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.grey,
          body: Center(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              constraints: const BoxConstraints(maxWidth: 700, maxHeight: 300),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "There was an isssue opening Sidekick",
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
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    label: const Text("Close"),
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      exit(0);
                    },
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

const text = "Sidekick is having trouble reading its settings."
    " Please make sure that there are no other instances of Sidekick running"
    " and try again. If the problem persists, please open a Github Issue.";
