import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/components/atoms/nav_button.dart';
import 'package:sidekick/components/atoms/shortcuts.dart';
import 'package:sidekick/components/organisms/app_bottom_bar.dart';
import 'package:sidekick/components/organisms/info_drawer.dart';
import 'package:sidekick/components/organisms/search_bar.dart';
import 'package:sidekick/constants.dart';
import 'package:sidekick/providers/navigation_provider.dart';
import 'package:sidekick/providers/selected_info_provider.dart';
import 'package:sidekick/screens/apps_screen.dart';
import 'package:sidekick/screens/explore_screen.dart';
import 'package:sidekick/screens/home_screen.dart';
import 'package:sidekick/screens/packages_screen.dart';
import 'package:sidekick/screens/settings_screen.dart';
import 'package:sidekick/utils/layout_size.dart';
import 'package:sidekick/utils/manage_updates.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();

final pages = [
  HomeScreen(key: UniqueKey()),
  AppsScreen(key: UniqueKey()),
  ExploreScreen(key: UniqueKey()),
  PackagesScreen(key: UniqueKey()),
  SettingsScreen(key: UniqueKey()),
];

class AppShell extends HookWidget {
  const AppShell({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LayoutSize.init(context);
    final navigation = useProvider(navigationProvider);
    final currentRoute = useProvider(navigationProvider.state);
    final selectedInfo = useProvider(selectedInfoProvider.state);

    final selectedIndex = useState(0);
    final showSearch = useState(false);

    final focusNode = useFocusNode();

    void handleIndexShortcut(NavigationRoutes route) {
      // TODO: Remove this workaround for keyboard shorcut access search
      if (route == NavigationRoutes.searchScreen) {
        showSearch.value = true;
      }
      navigation.goTo(route);
    }

    // Set current index or search based on route change
    useValueChanged(currentRoute, (_, __) {
      if (currentRoute == NavigationRoutes.searchScreen) {
        showSearch.value = true;
      } else {
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
      if (hasInfo && !isOpen && !LayoutSize.isLarge) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _scaffoldKey.currentState.openEndDrawer();
        });
      }

      // Close drawer layout if its large and its already open
      if (LayoutSize.isLarge && isOpen) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context);
        });
      }
    }, [selectedInfo, LayoutSize.size]);

    useEffect(() {
      checkForUpdates();
      return;
    }, []);

    return KBShortcutManager(
      onRouteShortcut: handleIndexShortcut,
      focusNode: focusNode,
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: !LayoutSize.isLarge ? const InfoDrawer() : Container(),
        bottomNavigationBar: const AppBottomBar(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              child: Row(
                children: <Widget>[
                  LayoutBuilder(
                    builder: (_, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: IntrinsicHeight(
                            child: NavigationRail(
                              leading: Container(
                                padding: const EdgeInsets.only(
                                  bottom: 15,
                                  left: 15,
                                  right: 15,
                                  top: 25,
                                ),
                                //constraints: BoxConstraints(maxWidth: 15),
                                child: Padding(
                                  padding: LayoutSize.isSmall
                                      ? EdgeInsets.zero
                                      : const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/logo.png",
                                        width: 50,
                                        gaplessPlayback: true,
                                      ),
                                      LayoutSize.isSmall
                                          ? Container()
                                          : Text(
                                              " Sidekick",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
                                            )
                                    ],
                                  ),
                                ),
                              ),
                              selectedIndex: selectedIndex.value,
                              minWidth: kNavigationWidth,
                              minExtendedWidth: kNavigationWidthExtended,
                              extended: !LayoutSize.isSmall,
                              onDestinationSelected: (index) {
                                // If its search
                                if (index == 5) {
                                  showSearch.value = true;
                                } else {
                                  navigation
                                      .goTo(NavigationRoutes.values[index]);
                                }
                              },
                              labelType: NavigationRailLabelType.none,
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
                                NavButton(
                                  label: 'Settings',
                                  iconData: Icons.settings,
                                ),
                                NavButton(
                                    label: 'Search', iconData: Icons.search),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  // This is the main content.
                  Expanded(
                    child: PageTransitionSwitcher(
                      duration: const Duration(milliseconds: 250),
                      reverse: selectedIndex.value <
                          (navigation.previous.index ?? 0),
                      child: pages[selectedIndex.value],
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
                  LayoutSize.isLarge
                      ? const VerticalDivider(width: 0)
                      : Container(),
                  LayoutSize.isLarge ? const InfoDrawer() : Container()
                ],
              ),
            ),
            SearchBar(
              showSearch: showSearch.value,
              onFocusChanged: (focus) async {
                // focusNode.requestFocus();
                if (showSearch.value != focus) {
                  showSearch.value = focus;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
