import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/components/organisms/terminal.dart';
import 'package:sidekick/dto/release.dto.dart';
import 'package:sidekick/providers/flutter_releases.provider.dart';
import 'package:sidekick/providers/terminal_provider.dart';

class PlaygroundScreen extends HookWidget {
  final Project project;

  const PlaygroundScreen({
    this.project,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final releases = useProvider(releasesStateProvider);
    final terminal = useProvider(terminalProvider);
    final selectedRelease = useState<ReleaseDto>();

    return Scaffold(
      // extendBodyBehindAppBar: true,
      // extendBody: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Subheading('Playground'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Colors.red, Colors.blue],
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black12,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            iconSize: 15,
            splashRadius: 15,
            onPressed: () {
              terminal.clear();
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Heading('Releases'),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: CupertinoScrollbar(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListView(
                        children: releases.allCached.map(
                          (version) {
                            if (version == selectedRelease.value) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ElevatedButton(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(version.name),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    selectedRelease.value = version;
                                  },
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextButton(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(version.name),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  selectedRelease.value = version;
                                },
                              ),
                            );
                          },
                        ).toList(),
                        // children: releases.allCached
                        //     .map(
                        //       (version) => ListTile(
                        //         selected: version == selectedRelease.value,
                        //         onTap: () {
                        //           selectedRelease.value = version;
                        //         },
                        //         title: Text(
                        //           version.name,
                        //           style: const TextStyle(fontSize: 12),
                        //         ),
                        //       ),
                        //     )
                        //     .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: PlaygroundTerminal(
              project: project,
              release: selectedRelease.value,
            ),
          ),
        ],
      ),
    );
  }
}
