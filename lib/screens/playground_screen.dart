import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
    final terminal = useProvider(terminalProvider.notifier);
    final processing = useProvider(terminalProvider).processing;

    final selectedRelease = useState<ReleaseDto>(null);

    useEffect(() {
      if (selectedRelease.value == null && releases.allCached.isNotEmpty) {
        selectedRelease.value = releases.allCached[0];
      }
      return;
    }, []);

    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(MdiIcons.playBox),
            SizedBox(width: 10),
            Subheading('Playground'),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Colors.red, Colors.blue],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            iconSize: 15,
            splashRadius: 15,
            onPressed: () {
              terminal.clearConsole();
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
                ListTile(
                  dense: true,
                  title: const Text('Releases'),
                  subtitle: Text('${releases.allCached.length} versions'),
                ),
                const Divider(height: 1),
                Expanded(
                  child: CupertinoScrollbar(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListView(
                        children: releases.allCached.map(
                          (version) {
                            if (version.name == selectedRelease.value?.name) {
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(
            width: 0,
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  dense: true,
                  title: Text(project.name),
                  subtitle: Text(project.projectDir.path),
                  trailing: processing
                      ? OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.deepOrange,
                            side: const BorderSide(
                              color: Colors.deepOrange,
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                          ),
                          onPressed: () {
                            terminal.endProcess();
                          },
                        )
                      : const OutlinedButton(
                          onPressed: null,
                          child: Text('Not running'),
                        ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: PlaygroundTerminal(
                    project: project,
                    release: selectedRelease.value,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
