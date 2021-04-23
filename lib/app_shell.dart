import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/components/atoms/nav_button.dart';
import 'package:sidekick/components/atoms/shortcuts.dart';
import 'package:sidekick/components/atoms/top_app_bar.dart';
import 'package:sidekick/components/organisms/app_bottom_bar.dart';
import 'package:sidekick/components/organisms/info_drawer.dart';
import 'package:sidekick/components/organisms/search_bar.dart';
import 'package:sidekick/constants.dart';
import 'package:sidekick/providers/navigation_provider.dart';
import 'package:sidekick/providers/selected_info_provider.dart';
import 'package:sidekick/screens/home_screen.dart';
import 'package:sidekick/screens/packages_screen.dart';
import 'package:sidekick/screens/projects_screen.dart';
import 'package:sidekick/screens/releases_screen.dart';
import 'package:sidekick/utils/layout_size.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();

class AppShell extends HookWidget {
  const AppShell({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LayoutSize.init(context);
    final navigation = useProvider(navigationProvider.notifier);
    final currentRoute = useProvider(navigationProvider);
    final selectedInfo = useProvider(selectedInfoProvider);
    // Index of item selected
    final selectedIndex = useState(0);

    // Side effect when route changes
    useValueChanged(currentRoute, (_, __) {
      // Do not set index if its search
      if (currentRoute != NavigationRoutes.searchScreen) {
        selectedIndex.value = currentRoute.index;
      }
    });

    // Side effect when info is selected
    useValueChanged(selectedInfo, (_, __) {
      if (_scaffoldKey.currentState == null) return;
      final isOpen = _scaffoldKey.currentState.isEndDrawerOpen;
      final hasInfo = selectedInfo.version != null;

      // Open drawer if not large layout and its not open
      if (hasInfo && !isOpen) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _scaffoldKey.currentState.openEndDrawer();
        });
      }
    });

    // Render corret page widget based on index
    Widget renderPage(int index) {
      const pages = [
        HomeScreen(),
        ProjectsScreen(),
        ReleasesScreen(),
        PackagesScreen(),
      ];

      return pages[index];
    }

    return KBShortcutManager(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: const InfoDrawer(),
        key: _scaffoldKey,
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: Colors.transparent,
              selectedIndex: selectedIndex.value,
              minWidth: kNavigationWidth,
              minExtendedWidth: kNavigationWidthExtended,
              extended: !LayoutSize.isSmall,
              leading: const SizedBox(height: 20),
              onDestinationSelected: (index) {
                navigation.goTo(NavigationRoutes.values[index]);
              },
              destinations: [
                NavButton(
                  label: 'Dashboard',
                  iconData: Icons.category,
                ),
                NavButton(
                  label: 'Projects',
                  iconData: MdiIcons.folderMultiple,
                ),
                NavButton(
                  label: 'Explore',
                  iconData: Icons.explore,
                ),
                NavButton(
                  label: 'Packages',
                  iconData: MdiIcons.package,
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: const TopAppBar(),
                    bottomNavigationBar: const AppBottomBar(),
                    body: Container(
                      child: Row(
                        children: <Widget>[
                          // This is the main content.
                          Expanded(
                            child: PageTransitionSwitcher(
                              duration: const Duration(milliseconds: 250),
                              reverse: selectedIndex.value <
                                  (navigation.previous.index ?? 0),
                              child: renderPage(selectedIndex.value),
                              transitionBuilder: (
                                child,
                                animation,
                                secondaryAnimation,
                              ) {
                                return SharedAxisTransition(
                                  fillColor: Colors.transparent,
                                  child: child,
                                  animation: animation,
                                  secondaryAnimation: secondaryAnimation,
                                  transitionType:
                                      SharedAxisTransitionType.vertical,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SearchBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
