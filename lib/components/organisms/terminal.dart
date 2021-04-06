import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/providers/terminal_provider.dart';
import 'package:sidekick/utils/terminal_processor.dart';
import 'package:xterm/frontend/terminal_view.dart';
import 'package:xterm/xterm.dart';

class PlaygroundTerminal extends HookWidget {
  const PlaygroundTerminal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stream = useProvider(terminalStreamProvider);
    final provider = useProvider(terminalProvider);
    final terminal = useState<Terminal>(Terminal(onInput: (input) {
      terminalProcessor.stdinSink.add(utf8.encode(input));
    }));

    useValueChanged(stream, (_, __) {
      if (terminal.value == null) return;
      terminal.value.write(stream.data.value);
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              children: [
                Expanded(
                  child: TerminalView(
                    terminal: terminal.value,
                    onResize: (width, height) {},
                  ),
                ),
                TextButton(onPressed: () {}, child: Text('flutter --version'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
