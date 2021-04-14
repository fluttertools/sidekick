import 'package:flutter/material.dart';
import 'package:sidekick/components/atoms/blur_background.dart';
import 'package:sidekick/components/atoms/typography.dart';

class Screen extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final bool processing;
  final Widget child;
  final bool extendBody;
  const Screen({
    @required this.title,
    this.actions = const [],
    this.processing = false,
    this.extendBody = true,
    this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: extendBody,
      extendBody: extendBody,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Stack(
          children: [
            const BlurBackground(),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  height: 59,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Heading(title),
                      const Spacer(),
                      ...actions,
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1,
                  child: processing
                      ? const LinearProgressIndicator()
                      : Container(),
                ),
              ],
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}
