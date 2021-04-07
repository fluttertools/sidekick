import 'dart:convert';

import 'package:async/async.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/utils/terminal_processor.dart';

enum OutputType {
  stderr,
  stdout,
}

class ConsoleLine {
  final OutputType type;
  final String text;
  ConsoleLine({
    this.type = OutputType.stdout,
    this.text,
  });

  factory ConsoleLine.empty() {
    return ConsoleLine(text: '');
  }

  factory ConsoleLine.stderr(String text) {
    return ConsoleLine(text: text, type: OutputType.stderr);
  }
}

final terminalProvider = StateNotifierProvider((ref) => TerminalState(ref));

class TerminalState extends StateNotifier<List<ConsoleLine>> {
  final ProviderReference ref;
  Stream<ConsoleLine> _terminalStream;
  TerminalState(this.ref) : super([]) {
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void clear() {
    state = [];
  }

  void add(String text) {
    final empty = ConsoleLine.empty();
    final line = ConsoleLine(
      text: text,
      type: OutputType.stdout,
    );
    state = [
      empty,
      line,
      empty,
      ...state,
    ];
  }

  void init() async {
    _terminalStream = StreamGroup.merge([
      terminalProcessor.stderr.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .map(
            (event) => ConsoleLine(
              type: OutputType.stderr,
              text: event,
            ),
          ),
      terminalProcessor.stdout.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .map(
            (event) => ConsoleLine(
              type: OutputType.stdout,
              text: event,
            ),
          ),
    ]).asBroadcastStream();

    // ref.onDispose(streams.close);

    await for (final value in _terminalStream) {
      state = [value, ...state];
    }
  }
}
