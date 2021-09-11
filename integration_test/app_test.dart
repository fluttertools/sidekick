// @dart=2.9
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'src/modules/common/app_shell_test.dart';
import 'src/modules/settings/settings_screen.dart';

import 'package:sidekick/main.dart' as app;

void main() async {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  setUpAll(() {});

  tearDownAll(() {});

  testWidgets('LiveTest', (WidgetTester tester) async {
    await tester.pumpWidget(await app.main(isTestMode: true));

    await AppShellTest.navigationTests(tester);
    await SettingsScreenTest.changeSettingsTests(tester);
  });
}
