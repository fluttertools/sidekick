import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:sidekick/src/components/molecules/top_app_bar.dart';
import 'package:sidekick/src/modules/settings/scenes/flutter_settings.scene.dart';
import 'package:sidekick/src/modules/settings/scenes/fvm_settings.scene.dart';
import 'package:sidekick/src/modules/settings/scenes/general_settings.scene.dart';
import 'package:sidekick/src/modules/settings/settings.screen.dart';

class SettingsScreenTest {
  static Future navigationTests(WidgetTester tester) async {
    expect(find.byType(SkAppBar), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.byType(SettingsSectionGeneral), findsOneWidget);

    await tester.tap(find.byIcon(MdiIcons.layers));
    await tester.pumpAndSettle();
    expect(find.byType(FvmSettingsScene), findsOneWidget);

    await tester.tap(find.byIcon(MdiIcons.console));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsSectionFlutter), findsOneWidget);

    await tester.tap(find.byType(CloseButton));
    await tester.pumpAndSettle();
    expect(find.byType(SkAppBar), findsOneWidget);
  }
}
