import 'dart:async';
import 'dart:isolate';

import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/dto/release.dto.dart';
import 'package:sidekick/utils/notify.dart';
import 'package:sidekick/utils/terminal_processor.dart';

class TerminalState {
  List<ConsoleLine> lines;
  bool processing;
  TerminalState(
    this.lines, {
    this.processing = false,
  });
}

enum OutputType {
  stderr,
  stdout,
  close,
  info,
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

  factory ConsoleLine.stdout(String text) {
    return ConsoleLine(text: text, type: OutputType.stdout);
  }

  factory ConsoleLine.info(String text) {
    return ConsoleLine(text: text, type: OutputType.info);
  }

  factory ConsoleLine.close() {
    return ConsoleLine(
      text: '',
      type: OutputType.close,
    );
  }
}

final terminalRunning = StateProvider((_) => false);

final terminalProvider = StateNotifierProvider(
  (ref) => TerminalStateNotifier(ref),
);

class TerminalStateNotifier extends StateNotifier<List<ConsoleLine>> {
  final ProviderReference ref;

  Isolate _isolate;

  TerminalStateNotifier(this.ref) : super([]);

  @override
  void dispose() {
    super.dispose();
  }

  void clearConsole() {
    state = [];
  }

  void kill() {
    _isolate.kill();

    addErr('\nProcess cancelled.');
    _notProcessing();
  }

  void _processing() {
    ref.read(terminalRunning).state = true;
  }

  void _notProcessing() {
    ref.read(terminalRunning).state = false;
  }

  Future<void> reboot(
    ReleaseDto release,
    Project project,
  ) async {
    /// Clear console
    clearConsole();
    // Kill if there is an isolate running
    _isolate.kill();

    add(
      'Rebooting environment for ${project.name}...\n'
      'Flutter SDK (${release.name}) running on ${project.projectDir.path}\n\n',
    );

    await sendIsolate(
      'flutter --version',
      release,
      project,
      supressCmdOutput: true,
    );
  }

  Future<void> sendIsolate(
    String cmd,
    ReleaseDto release,
    Project project, {

    /// Supress display command on terminal
    bool supressCmdOutput = false,
  }) async {
    try {
      String execPath;

      final args = cmd.split(' ');
      final firstArg = args.removeAt(0);

      if (firstArg == 'flutter') {
        execPath = release.cache.flutterExec;
      } else if (firstArg == 'dart') {
        execPath = release.cache.dartExec;
      } else {
        addErr('Can only use "flutter" and "dart" commands');
        return;
      }

      // Send command to terminal
      if (!supressCmdOutput) {
        add('\n$cmd\n');
      }

      _processing();
      final receivePort = ReceivePort();

      final terminalCmd = TerminalCmd(
        execPath: execPath,
        workingDirectory: project.projectDir.path,
        args: args,
        sendPort: receivePort.sendPort,
      );

      _isolate = await Isolate.spawn(isolateProcess, terminalCmd);

      await for (final value in receivePort) {
        final line = value as ConsoleLine;

        // Close isolate
        if (line.type == OutputType.close) {
          receivePort.close();
          _isolate.kill();
        } else {
          state = [line, ...state];
        }
      }
    } on Exception catch (e) {
      notifyError(e.toString());
    } finally {
      _notProcessing();
    }
  }

  void add(String text) {
    final lines = [
      ConsoleLine.info(text),
    ];
    state = [...lines, ...state];
  }

  void addErr(String text) {
    final line = ConsoleLine.stderr(text);
    state = [line, ...state];
  }
}
