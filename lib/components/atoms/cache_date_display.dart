import 'dart:io';

import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../dto/release.dto.dart';

class CacheDateDisplay extends HookWidget {
  final ReleaseDto version;
  const CacheDateDisplay(this.version, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cacheDirStat = useState<FileStat>(null);

    void setCacheDir() async {
      if (version != null && version.isCached == true) {
        cacheDirStat.value = await version.cache.dir.stat();
      }
    }

    useEffect(() {
      setCacheDir();
      return;
    }, [version]);

    if (cacheDirStat.value == null) {
      return const SizedBox(height: 0);
    }

    return Text(DateTimeFormat.format(
      cacheDirStat.value.changed,
      format: AmericanDateFormats.abbr,
    ));
  }
}
