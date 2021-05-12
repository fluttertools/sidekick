import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../atoms/typography.dart';

// TODO: Make this generic
class InfoBanner extends StatelessWidget {
  const InfoBanner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 80,
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
            children: const [
              SizedBox(width: 10),
              Subheading('Master'),
              SizedBox(width: 20),
              Expanded(
                child: Caption(
                  '''The current tip-of-tree, absolute latest cutting edge build. '''
                  '''Usually functional, though sometimes we accidentally break things.''',
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
