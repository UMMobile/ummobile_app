import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/tabs/models/page_tab_view.dart';

class NavigationController extends GetxController {
  final List<PageTabView> tabs;
  final TickerProvider ticker;
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  NavigationController({required this.tabs, required this.ticker});

  late TabController tabController;

  var selectedIndex = 0.obs;

  List<Widget> mainTabs = [];
  // one buildContext for each tab to store history  of navigation
  late List<BuildContext?> navStack;
  List<BottomNavigationBarItem> bottomNavigationBarRootItems = [];

  @override
  void onInit() {
    tabController = TabController(length: tabs.length, vsync: ticker);
    navStack = []..length = tabs.length;
    for (int i = 0; i < tabs.length; i++) {
      //navigationKeys.add(GlobalKey());
      mainTabs.add(
        Navigator(
            key: Get.nestedKey(i),
            onGenerateRoute: (RouteSettings settings) {
              return PageRouteBuilder(pageBuilder: (context, animiX, animiY) {
                navStack[i] = context;
                return tabs[i].page;
              });
            }),
      );
      bottomNavigationBarRootItems.add(
        BottomNavigationBarItem(
          icon: tabs[i].icon,
          label: tabs[i].label,
        ),
      );
    }
    super.onInit();
  }

  /// * Mehod that changes to the selected page in the bottomNavigation
  changeStatus(int selectIndex, tabIndex) {
    if (tabIndex != null) {
      tabController.animateTo(tabIndex);
    }
    selectedIndex(selectIndex);
  }

  /// * Mehod that evaluates the status of the page and realize an action based on
  /// * a set of condition
  void onItemTapped(int index) {
    /// return to the main page if the users selects the selectedPage and is in a
    /// subpage of that page
    if (index == selectedIndex.value) {
      if (Navigator.of(navStack[tabController.index]!).canPop()) {
        do {
          Navigator.of(navStack[tabController.index]!).pop();
        } while (Navigator.of(navStack[tabController.index]!).canPop());
      }
    }

    changeStatus(index, index);
  }

  /// * Mehod used to navigate to a subpage inside a tab Page
  void goToSubTabView(Widget widget, BuildContext context) {
    Get.to(
      () => widget,
      id: selectedIndex.value,
    );
  }
}
