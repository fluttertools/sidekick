import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:sidekick/src/modules/fvm/fvm.screen.dart';
import 'package:sidekick/src/modules/projects/projects.screen.dart';
import 'package:sidekick/src/modules/releases/releases.screen.dart';

import '../settings/settings_screen.dart';

class AppShellTest {
  static Future<void> navigationTests(WidgetTester tester) async {
    await Future.delayed(const Duration(seconds: 2));

    ///---Navigation-Rail
    /// Navigation Rail is visible and ready to test
    expect(find.byType(NavigationRail), findsOneWidget);

    await tester.tap(find.byIcon(Icons.category));
    await tester.pumpAndSettle();
    expect(find.byType(FVMScreen), findsOneWidget);

    await tester.tap(find.byIcon(MdiIcons.folderMultiple));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectsScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.explore));
    await tester.pumpAndSettle();
    expect(find.byType(ReleasesScreen), findsOneWidget);

    ///---Navigation-Rail

    /// Settings Screen
    await SettingsScreenTest.navigationTests(tester);
  }
}
