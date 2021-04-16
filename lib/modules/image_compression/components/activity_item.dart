import 'package:flutter/material.dart';
import 'package:sidekick/modules/image_compression/image_compression_screen.dart';

class ActivityItem extends StatelessWidget {
  final CompressActivity activity;
  const ActivityItem({
    this.activity,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [Image.asset(name)],
      ),
    );
  }
}
