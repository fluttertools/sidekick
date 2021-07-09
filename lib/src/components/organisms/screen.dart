import 'package:flutter/material.dart';
import 'package:sidekick/src/components/atoms/typography.dart';

import '../atoms/blur_background.dart';

/// Generic Sidekick screen widget
class SkScreen extends StatelessWidget {
  /// Constructor
  const SkScreen({
    @required this.title,
    this.actions = const [],
    this.processing = false,
    this.extendBody = true,
    this.child,
    Key key,
  }) : super(key: key);

  /// Screen title
  final String title;

  /// Screen actions
  final List<Widget> actions;

  /// Is it processing
  final bool processing;

  /// Child widget
  final Widget child;

  /// Should extend body
  final bool extendBody;
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
