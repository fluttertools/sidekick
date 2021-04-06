import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fvm/fvm.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/dto/release.dto.dart';

class PlaygroundScreen extends HookWidget {
  final Project project;
  final ReleaseDto release;
  const PlaygroundScreen({
    this.project,
    this.release,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: const Subheading('Playground'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            iconSize: 15,
            splashRadius: 15,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Row(
        children: [
          Container(),
          Container(),
        ],
      ),
    );
  }
}
