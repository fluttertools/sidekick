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
  List<String> _cmdHistory;

  TerminalState({
    this.lines,
    this.processing = false,
    List<String> cmdHistory,
  }) : _cmdHistory = cmdHistory;

  factory TerminalState.empty() {
    return TerminalState(
      lines: [],
      processing: false,
      cmdHistory: [
        'flutter 1',
        'flutter 2',
        'flutter 3',
        'flutter 4',
      ],
    );
  }

  List<String> get cmdHistory {
    // Add empty command as the current
    final history = ['', ..._cmdHistory];
    return history;
  }

  void addToHistory(String cmd) {
    _cmdHistory.insert(0, cmd);
  }

  void addConsoleLine(ConsoleLine line) {
    lines.insert(0, line);
  }

  void addLine(String text) {
    final line = ConsoleLine.info(text);
    addConsoleLine(line);
  }

  void addLineStdout(String text) {
    final line = ConsoleLine.stdout(text);
    addConsoleLine(line);
  }

  void addLineErr(String text) {
    final line = ConsoleLine.stderr(text);
    addConsoleLine(line);
  }

  /// Clears lines and processing status
  /// Keeps history
  void clearConsole() {
    lines = [];
    processing = false;
  }

  TerminalState copy() {
    return TerminalState(
      lines: lines,
      processing: processing,
      cmdHistory: _cmdHistory,
    );
  }
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

final terminalProvider = StateNotifierProvider(
  (ref) => TerminalStateNotifier(ref),
);

class TerminalStateNotifier extends StateNotifier<TerminalState> {
  final ProviderReference ref;

  Isolate _isolate;

  TerminalStateNotifier(this.ref) : super(TerminalState.empty());

  void _notifyListeners() {
    state = state.copy();
  }

  void clearConsole() {
    state.clearConsole();
    _notifyListeners();
  }

  void _killIsolate() {
    if (_isolate != null) {
      _isolate.kill();
    }
  }

  void endProcess() {
    _killIsolate();
    state.addLineErr('\nProcess cancelled.');
    state.processing = false;
    _notifyListeners();
  }

  Future<void> reboot(
    ReleaseDto release,
    Project project,
  ) async {
    /// Clear console
    clearConsole();
    // Kill if there is an isolate running
    _killIsolate();

    state.addLine(
      'Rebooting environment for ${project.name}...\n'
      'Flutter SDK (${release.name}) running on ${project.projectDir.path}\n\n',
    );

    _notifyListeners();

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
        state.addLineErr('Can only use "flutter" and "dart" commands');
        _notifyListeners();
        return;
      }

      // Send command to terminal
      if (!supressCmdOutput) {
        // Add to command history
        //
        state.addToHistory(cmd);
        state.addLine('\n$cmd\n');
      }

      // Set to processing
      state.processing = true;
      // Notify listeners
      _notifyListeners();
      // Receiver port for isolate
      final receivePort = ReceivePort();
      // Create model of Terminal Cmd to send to isolate
      final terminalCmd = TerminalCmd(
        execPath: execPath,
        workingDirectory: project.projectDir.path,
        args: args,
        sendPort: receivePort.sendPort,
      );

      // Spawn isolate and sets it for later access
      _isolate = await Isolate.spawn(isolateProcess, terminalCmd);

      // Receive date from receiver
      await for (final value in receivePort) {
        final line = value as ConsoleLine;

        // Close isolate
        if (line.type == OutputType.close) {
          receivePort.close();
          _killIsolate();
        } else {
          state.lines = [line, ...state.lines];
        }
      }
    } on Exception catch (e) {
      notifyError(e.toString());
    } finally {
      state.processing = false;
      _notifyListeners();
    }
  }
}
