// @dart=2.9
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'src/modules/common/app_shell_test.dart';

void main() async {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  setUpAll(() {});

  tearDownAll(() {});

  await AppShellTest.navigationTests();
}
