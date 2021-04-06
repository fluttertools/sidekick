import 'dart:convert';

import 'package:async/async.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/utils/terminal_processor.dart';

final terminalStreamProvider = StreamProvider.autoDispose<String>((ref) async* {
  final streams = StreamGroup.merge([
    terminalProcessor.stderr.stream,
    terminalProcessor.stdout.stream,
  ]).transform(utf8.decoder).asBroadcastStream();

  // ref.onDispose(streams.close);

  await for (final value in streams) {
    yield value;
  }
});

final terminalProvider = StateNotifierProvider((ref) => TerminalState(ref));

class TerminalState extends StateNotifier<List<int>> {
  final ProviderReference ref;

  TerminalState(this.ref) : super([]) {
    init();
  }

  void init() async {
    await runCmd('bash', []);
  }
}
