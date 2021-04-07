import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/dto/release.dto.dart';
import 'package:sidekick/providers/terminal_provider.dart';
import 'package:sidekick/utils/notify.dart';
import 'package:sidekick/utils/terminal_processor.dart';

class PlaygroundTerminal extends HookWidget {
  final Project project;
  final ReleaseDto release;
  const PlaygroundTerminal({
    this.project,
    this.release,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lines = useProvider(terminalProvider.state);
    final terminal = useProvider(terminalProvider);

    final textController = useTextEditingController();
    final scrollController = useScrollController();
    final processing = useState(false);
    final focus = useFocusNode();

    useEffect(() {
      // Gain back focus
      if (!processing.value) {
        focus.requestFocus();
      }
    }, [processing.value]);

    void submitCmd(String value) async {
      try {
        processing.value = true;

        String execPath;
        // TODO: Clean this up
        final args = value.split(' ');
        final firstArg = args.removeAt(0);

        if (firstArg == 'flutter') {
          execPath = release.cache.flutterExec;
        } else if (firstArg == 'dart') {
          execPath = release.cache.dartExec;
        } else {
          notifyError('Can only use "flutter" and "dart" commands');
          return;
        }

        // Send command to terminal
        terminal.add('$value');
        // Clear controller
        textController.clear();
        scrollController.jumpTo(0);

        await runCmd(
          execPath,
          args,
          workingDirectory: project.projectDir.path,
        );
      } on Exception catch (e) {
        notifyError(e.toString());
      } finally {
        processing.value = false;
      }
    }

    return Column(
      children: [
        Expanded(
          child: CupertinoScrollbar(
            child: ListView.builder(
              controller: scrollController,
              reverse: true,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              itemBuilder: (context, index) {
                final line = lines[index];
                if (line.type == OutputType.stdout) {
                  return StdoutText(line.text);
                }

                if (line.type == OutputType.stderr) {
                  return TextStderr(line.text);
                }
              },
              itemCount: lines.length,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  enabled: !processing.value,
                  controller: textController,
                  onSubmitted: submitCmd,
                  focusNode: focus,
                  decoration: const InputDecoration(
                    icon: Icon(MdiIcons.chevronRight),
                    border: InputBorder.none,
                  ),
                ),
              ),
              processing.value
                  ? const SpinKitFadingFour(color: Colors.cyan, size: 15)
                  : Container()
            ],
          ),
        ),
      ],
    );
  }
}
