import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ummobile/modules/drawer/controllers/drawer.dart';
import 'package:ummobile/modules/drawer/modules/portal/portal_exports.dart';
import 'package:ummobile/modules/drawer/modules/settings/views/page_settings.dart';
import 'package:ummobile/modules/login/utils/roles_pages.dart';
import 'package:ummobile/modules/login/utils/validate_login.dart';
import 'package:ummobile/modules/tabs/bindings/tabs_binding.dart';
import 'package:ummobile/modules/tabs/controllers/navigation_controller.dart';
import 'package:ummobile/modules/tabs/modules/profile/models/user_credentials.dart';
import 'package:ummobile/services/storage/quick_login.dart';
import 'package:ummobile/statics/settings/app_icons_icons.dart';
import 'package:ummobile/statics/settings/colors.dart';
import 'package:ummobile/statics/widgets/overlays/dialog_overlay.dart';

import 'widgets/item_site.dart';

class UmDrawer extends StatefulWidget {
  UmDrawer({Key? key}) : super(key: key);

  @override
  _UmDrawerState createState() => _UmDrawerState();
}

class _UmDrawerState extends State<UmDrawer> {
  /// The path of the default image if user image is unavailable
  final String pathImage = "assets/img/default-img.jpg";

  final drawerController = Get.put(UmDrawerController());

  @override
  void deactivate() {
    super.deactivate();
    // First is marked as closed
    drawerController.updateIsOpen(false);
    // Then, if need to be delete, the controller is deleted.
    if (drawerController.needToBeDelete) {
      Get.delete<UmDrawerController>();
    }
  }

  @override
  void initState() {
    super.initState();
    drawerController.updateIsOpen(true);
  }

  /// Returns a list of widget tiles from the [pages] given
  List<Widget> _itemsForSection({List<Map<String, dynamic>> pages: const []}) {
    List<Widget> items = [];
    pages.forEach((page) {
      items.add(
        _singleSectionItem(
          page: page['page'],
          title: page['title'] ?? '',
          icon: page['icon'],
          binding: page['binding'],
        ),
      );
    });
    return items;
  }

  /// Returns a tile for the list drawer
  ///
  /// Note: Use the parameter page if you want to send the user to other page,
  ///  use the parameter tabIndex if you want to move the user to a specific tab
  /// in the home page
  Widget _singleSectionItem({
    required String title,
    Widget? page,
    int? tabIndex,
    IconData? icon,
    Bindings? binding,
  }) {
    return InkWell(
      splashColor: Colors.white.withOpacity(0.3),
      onTap: () async {
        if (page != null) {
          drawerController.changeView(page, binding);
        } else if (tabIndex != null) {
          Get.back();
          Get.find<NavigationController>().onItemTapped(tabIndex);
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(icon, size: 16),
                ),
                Text(
                  title,
                ),
              ],
            ),
          ),
          Divider(height: 0),
        ],
      ),
    );
  }

  /// Returns the external sites module widget section base from the [sites] list
  List<Widget> _sites(List<dynamic> sites) {
    List<Widget> sitesItems = [];
    sites.forEach((value) {
      sitesItems.add(ItemSite(
        imagePath: value['imagePath'],
        url: value['url'],
        size: 60,
        separation: 10,
      ));
    });
    return sitesItems;
  }

  @override
  Widget build(BuildContext context) {
    final Widget header = Container(
      height: 180,
      child: DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.only(left: 12, right: 14),
        decoration: BoxDecoration(
          gradient: AppColorThemes.colorSecondary,
        ),
        child: drawerController.obx(
          (user) => Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    border: Border.all(width: 3.0, color: Colors.white),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: (drawerController.state!.image!.isNotEmpty)
                          ? MemoryImage(
                              base64Decode(drawerController.state!.image!))
                          : AssetImage('assets/img/default-img.jpg')
                              as ImageProvider<Object>,
                    )),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 12, top: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drawerController.state!.name,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: "Lato",
                          color: Colors.white,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          height: 24,
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                  ),
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  primary: Colors.white,
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                                onPressed: () {
                                  Get.back();
                                  Get.find<NavigationController>().onItemTapped(
                                      viewsForCurrentUser().length - 1);
                                },
                                child: Text(
                                  'see'.tr + " " + 'profile'.tr,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          onError: (e) => Center(
            child: Text(e.toString()),
          ),
        ),
      ),
    );

    /// The list of pages inside the drawer
    List<Widget> portalSectionChildren = _itemsForSection(pages: [
      {
        'page': SubjectsPage(),
        'title': 'subjects'.tr.capitalizeFirst!,
        'icon': Icons.library_books_rounded,
        'binding': CurrentSubjectsBinding(),
      },
      {
        'page': ScoresPage(),
        'title': 'scores'.tr.capitalizeFirst!,
        'icon': Icons.school_rounded,
        'binding': ScoresBinding(),
      },
      {
        'page': LedgerPage(),
        'title': 'ledger'.tr.capitalizeFirst!,
        'icon': Icons.attach_money_rounded,
        'binding': LedgerBinding(),
      },
      {
        'page': DocumentsPage(),
        'title': 'archives'.tr.capitalizeFirst!,
        'icon': Icons.description_rounded,
        'binding': DocumentsBinding(),
      },
    ]);

    /// The list of external sites
    List<Widget> sitesSectionChildren = _sites([
      {
        'imagePath': 'assets/img/sitesImg/e42.svg',
        'url': 'https://e42.um.edu.mx/',
      },
      {
        'imagePath': 'assets/img/sitesImg/academico.svg',
        'url': 'https://virtual-um.um.edu.mx/',
      },
      {
        'imagePath': 'assets/img/sitesImg/conectate.svg',
        'url': 'https://conectate.um.edu.mx/',
      },
      {
        'imagePath': 'assets/img/sitesImg/UMTV.svg',
        'url': 'http://umtv.mx/',
      }
    ]);

    final Widget logout = ListTile(
      leading: Icon(
        Icons.logout,
        color: Colors.red,
      ),
      title: Text(
        "logout".tr.capitalizeFirst!,
        style: TextStyle(color: Colors.red),
      ),
      onTap: () {
        openDialogWindow(
          title: "logout".tr.capitalizeFirst!,
          message: "logout_message".tr,
          onCancel: () => Get.back(),
          onConfirm: () async {
            openLoadingDialog("Cerrando sesion");
            QuickLogins(await getApplicationDocumentsDirectory())
                .inactiveAllSessions();
            drawerController.updateNeedToBeDelete(true);
            TabsBinding().reset();
            logoutTransition();
          },
        );
      },
    );

    return Drawer(
      child: Column(
        children: [
          header,
          Flexible(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _singleSectionItem(
                  tabIndex: 0,
                  title: 'home'.tr.capitalizeFirst!,
                  icon: Icons.home,
                ),
                if (userIsStudent)
                  ExpansionTile(
                    initiallyExpanded: true,
                    leading: Icon(AppIcons.virtual, size: 20),
                    title: Text('academic_portal'.tr),
                    backgroundColor: Get.theme.dividerColor,
                    children: portalSectionChildren,
                  ),
                if (userIsEmployee)
                  _singleSectionItem(
                    page: LedgerPage(),
                    title: 'ledger'.tr.capitalizeFirst!,
                    icon: Icons.attach_money_rounded,
                    binding: LedgerBinding(),
                  ),
              ],
            ),
          ),
          _singleSectionItem(
            page: SettingsPage(),
            title: 'settings'.tr,
            icon: Icons.settings,
          ),
          ExpansionTile(
            initiallyExpanded: true,
            leading: Icon(Icons.open_in_new_rounded, size: 18),
            title: Text('interests_sites_list_header'.tr),
            childrenPadding: EdgeInsets.only(bottom: 18),
            children: [
              Container(
                height: 60,
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: sitesSectionChildren,
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 0),
          logout,
        ],
      ),
    );
  }
}
