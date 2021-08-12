// @dart=2.9
import 'package:sidekick/main_test.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() async {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  setUpAll(() {});

  tearDownAll(() {});

  group('E2E Tests', () {
    testWidgets('Test 1 works', (WidgetTester tester) async {
      await tester.pumpWidget(await app.main());

      await Future.delayed(const Duration(seconds: 2));
    });

    testWidgets('Test 2 works', (WidgetTester tester) async {
      await tester.pumpWidget(await app.main());

      await Future.delayed(const Duration(seconds: 2));
    });
  });
}
