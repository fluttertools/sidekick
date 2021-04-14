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
    final navigation = useProvider(navigationProvider);
    final currentRoute = useProvider(navigationProvider.state);
    final selectedInfo = useProvider(selectedInfoProvider.state);

    final selectedIndex = useState(0);

    useValueChanged(currentRoute, (_, __) {
      // Do not set index if its search
      if (currentRoute != NavigationRoutes.searchScreen) {
        selectedIndex.value = currentRoute.index;
      }
    });

    // Logic for displaying or hiding drawer based on layout
    // ignore: missing_return
    useEffect(() {
      if (_scaffoldKey.currentState == null) return;
      final isOpen = _scaffoldKey.currentState.isEndDrawerOpen;
      final hasInfo = selectedInfo.version != null;

      // Open drawer if not large layout and its not open
      if (hasInfo && !isOpen) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _scaffoldKey.currentState.openEndDrawer();
        });
      }

      // Close drawer layout if its large and its already open
    }, [selectedInfo]);

    Widget renderPage(int index) {
      const pages = [
        HomeScreen(),
        ProjectsScreen(),
        ReleasesScreen(),
        PackagesScreen(),
      ];

      return pages[index];
    }

    ;

    ;

    return KBShortcutManager(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Scaffold(
              endDrawer: const InfoDrawer(),
              appBar: const TopAppBar(),
              key: _scaffoldKey,
              bottomNavigationBar: const AppBottomBar(),
              body: Container(
                child: Row(
                  children: <Widget>[
                    NavigationRail(
                      selectedIndex: selectedIndex.value,
                      minWidth: kNavigationWidth,
                      minExtendedWidth: kNavigationWidthExtended,
                      extended: !LayoutSize.isSmall,
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
                            transitionType: SharedAxisTransitionType.vertical,
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
    );
  }
}
