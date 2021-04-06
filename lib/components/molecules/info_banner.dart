import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../atoms/typography.dart';

class InfoBanner extends StatelessWidget {
  const InfoBanner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: true ? 80 : 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.deepOrange.withOpacity(0.1),
            border: Border.all(
              color: Colors.deepOrange,
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              const Subheading('Master'),
              const SizedBox(width: 20),
              const Expanded(
                child: Caption(
                    '''The current tip-of-tree, absolute latest cutting edge build. Usually functional, though sometimes we accidentally break things.'''),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
