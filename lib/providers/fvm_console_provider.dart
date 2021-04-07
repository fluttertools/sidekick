import 'dart:convert';

import 'package:async/async.dart';
import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final combinedConsoleProvider = StreamProvider.autoDispose((ref) {
  return StreamGroup.merge([
    FVMClient.console.stdout.stream,
    FVMClient.console.stderr.stream,
    FVMClient.console.warning.stream,
    FVMClient.console.info.stream,
    FVMClient.console.fine.stream,
    FVMClient.console.error.stream,
  ])
      .transform(utf8.decoder)
      // .transform(const LineSplitter())
      .asBroadcastStream();
});
