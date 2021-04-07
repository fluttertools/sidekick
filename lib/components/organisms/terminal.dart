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
    final processing = useProvider(terminalRunning).state;

    final textController = useTextEditingController();
    final scrollController = useScrollController();

    final focus = useFocusNode();

    void submitCmd(
      String value,
    ) async {
      try {
        textController.clear();
        await terminal.sendIsolate(
          value,
          release,
          project,
        );
        // Clear controller
        scrollController.jumpTo(0);
      } on Exception catch (e) {
        notifyError(e.toString());
      }
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await terminal.reboot(release, project);
      });
    }, [release]);

    useEffect(() {
      // Gain back focus
      if (!processing) {
        focus.requestFocus();
      }
    }, [processing]);

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
                switch (line.type) {
                  case OutputType.stderr:
                    return StderrText(line.text);
                  case OutputType.info:
                    return StdinfoText(line.text);
                  case OutputType.stdout:
                    return StdoutText(line.text);
                  default:
                    return Container();
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
                  enabled: !processing,
                  controller: textController,
                  onSubmitted: submitCmd,
                  focusNode: focus,
                  decoration: const InputDecoration(
                    icon: Icon(MdiIcons.chevronRight),
                    border: InputBorder.none,
                  ),
                ),
              ),
              processing
                  ? const SpinKitFadingFour(color: Colors.cyan, size: 15)
                  : Container()
            ],
          ),
        ),
      ],
    );
  }
}
