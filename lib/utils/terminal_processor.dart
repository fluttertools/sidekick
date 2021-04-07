import 'dart:async';
import 'dart:io';

final terminalProcessor = TerminalProcessor();

Future<int> runCmd(
  String cmd,
  List<String> args, {
  Map<String, String> environment,
  String workingDirectory,
}) async {
  final process = await Process.start(
    cmd,
    args,
    environment: environment,
    workingDirectory: workingDirectory,
  );

  terminalProcessor.stderr.addStream(process.stderr);
  terminalProcessor.stdout.addStream(process.stdout);
  terminalProcessor.stdinSink = process.stdin;

  exitCode = await process.exitCode;

  // await terminalProcessor.stdinSink.flush();
  // await terminalProcessor.stderr.close();
  // await terminalProcessor.stdout.close();

  return exitCode;
}

/// Console Controller
class TerminalProcessor {
  /// stdout stream
  final stdout = StreamController<List<int>>();

  /// sderr stream
  final stderr = StreamController<List<int>>();

  IOSink stdinSink;
}
