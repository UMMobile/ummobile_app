import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/controllers/appbar_controller.dart';
import 'package:ummobile/modules/app_bar/modules/rules/models/rules.dart';
import 'package:ummobile/modules/app_bar/modules/page_exports.dart';
import 'package:ummobile/modules/tabs/modules/profile/models/user_credentials.dart';

import 'package:ummobile/statics/settings/colors.dart';

import '../../../statics/Widgets/badge.dart' as badge;
import '../modules/questionnaire/views/servicesevaluationspage.dart';

class UmAppBar extends StatelessWidget with PreferredSizeWidget {
  /// title widget to display in the appBar
  /// NOTE: if the widget is just a text use title field instead to apply decorations
  final Widget? child;

  /// title text to display in the appBar
  final String? title;

  /// Changes the appbar defaults leading widget
  final Widget? leading;

  /// The height of the appbar
  ///
  /// Defaults to kToolBarHeight + 20
  final double height;

  /// Wether to show or not the trailing icons
  final bool showActionIcons;

  ///The widgets that will appear at the right side
  final List<Widget>? customActions;

  /// The size of the header icons
  final double _iconsSize = 24.0;

  UmAppBar({
    this.child,
    this.leading,
    this.height = kToolbarHeight + 20,
    this.showActionIcons = true,
    this.customActions,
    this.title,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      toolbarHeight: height,
      title: (title != null)
          ? Text(
              title!,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            )
          : child,
      actions: (showActionIcons) ? _actions() : null,
      leading: leading ?? null,
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: AppColorThemes.colorSecondary),
      ),
    );
  }

  List<Widget> _actions() {
    if (customActions != null) return customActions!;
    return <Widget>[
      GetX<AppBarController>(builder: (_) {
        return Row(
          children: <Widget>[
            IconButton(
              onPressed: () => Get.to(
                  () => SchoolRules(
                        rules: userIsStudent
                            ? [
                                Rule(
                                  name: "student_rules".tr,
                                  pdfUrl: Uri.parse(
                                    'https://um.edu.mx/descargas/reglamento.pdf',
                                  ),
                                ),
                                Rule(
                                  name: 'legislation_undergraduate'.tr,
                                  pdfUrl: Uri.parse(
                                    'https://um.edu.mx/descargas/leg_pregrado.pdf',
                                  ),
                                ),
                                Rule(
                                  name: 'legislation_posgraduate'.tr,
                                  pdfUrl: Uri.parse(
                                    'https://um.edu.mx/descargas/leg_posgrado.pdf',
                                  ),
                                ),
                              ]
                            : [
                                Rule(
                                  name: 'policy_manual'.tr,
                                  pdfUrl: Uri.parse(
                                    'https://virtual-um.um.edu.mx/financiero/rh/formularios/ManualDePoliticas.pdf',
                                  ),
                                ),
                                Rule(
                                  name: 'student_rules'.tr,
                                  pdfUrl: Uri.parse(
                                    'https://um.edu.mx/descargas/reglamento.pdf',
                                  ),
                                ),
                                Rule(
                                  name: 'legislation_undergraduate'.tr,
                                  pdfUrl: Uri.parse(
                                    'https://um.edu.mx/descargas/leg_pregrado.pdf',
                                  ),
                                ),
                                Rule(
                                  name: 'legislation_posgraduate'.tr,
                                  pdfUrl: Uri.parse(
                                    'https://um.edu.mx/descargas/leg_posgrado.pdf',
                                  ),
                                ),
                              ],
                      ),
                  transition: Transition.downToUp),
              icon: badge.Badge(
                top: 15,
                right: -5,
                value: _.rulesCounter.value.toString(),
                child: Icon(
                  Icons.explore_outlined,
                  size: this._iconsSize,
                ),
              ),
            ),
            if (userIsEmployee)
              IconButton(
                onPressed: () => Get.to(() => QuestionnairesPage(),
                    transition: Transition.downToUp),
                icon: Icon(
                  Icons.run_circle_outlined,
                  size: this._iconsSize,
                ),
              ),
            if (userIsStudent)
              IconButton(
                onPressed: () => Get.to(() => ServicesEvluationPage(),
                    transition: Transition.downToUp),
                icon: Icon(
                  Icons.add_comment_outlined,
                  size: this._iconsSize,
                ),
              ),
            IconButton(
              onPressed: () => Get.to(() => NotificationsPage(),
                  transition: Transition.downToUp),
              icon: badge.Badge(
                top: 15,
                right: -5,
                value: _.searchNewNotifications().toString(),
                child: Icon(
                  _.searchNewNotifications() == 0
                      ? Icons.notifications_none
                      : Icons.notifications,
                  size: this._iconsSize,
                ),
              ),
            ),
          ],
        );
      })
    ];
  }
}
