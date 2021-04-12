import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:sidekick/providers/terminal_provider.dart';

class TerminalCmd {
  final List<String> args;
  final String execPath;
  final String workingDirectory;
  final SendPort sendPort;
  TerminalCmd({
    this.args,
    this.execPath,
    this.workingDirectory,
    this.sendPort,
  });
}

Future<void> isolateProcess(TerminalCmd cmd) async {
  try {
    final process = await Process.start(
      cmd.execPath,
      cmd.args,
      workingDirectory: cmd.workingDirectory,
    );

    process.stdout
        .transform(utf8.decoder)
        .transform(
          const LineSplitter(),
        )
        .listen(
      (event) {
        cmd.sendPort.send(
          ConsoleLine.stdout(event),
        );
      },
    );

    process.stderr
        .transform(utf8.decoder)
        .transform(
          const LineSplitter(),
        )
        .listen(
      (event) {
        cmd.sendPort.send(
          ConsoleLine.stderr(event),
        );
      },
    );

    await process.exitCode;

    // Trigger close receive port
    cmd.sendPort.send(ConsoleLine.close());
  } on Exception catch (e) {
    cmd.sendPort.send(
      ConsoleLine(
        text: e.toString(),
        type: OutputType.stderr,
      ),
    );
  }
}
