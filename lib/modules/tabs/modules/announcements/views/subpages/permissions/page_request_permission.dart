import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/tabs/modules/forms/controllers/permissions_controller.dart';
import 'package:ummobile/modules/tabs/modules/forms/views/widgets/submit_button.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/statics/Widgets/form/bottomsheet/botomsheet.dart';

import 'forms/form_institutional.dart';
import 'forms/form_other.dart';

class RequestPermissionsPage extends StatefulWidget {
  RequestPermissionsPage({Key? key}) : super(key: key);

  @override
  _RequestPermissionsPageState createState() => _RequestPermissionsPageState();
}

class _RequestPermissionsPageState extends State<RequestPermissionsPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PermissionsController>(
        init: PermissionsController(),
        builder: (_) {
          return Scaffold(
            appBar: UmAppBar(
              title: "request_verb".trParams({
                'element': "permission".tr,
              }).capitalizeFirst!,
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: ListView(
                physics: BouncingScrollPhysics(),
                addAutomaticKeepAlives: true,
                children: <Widget>[
                  BottomSheetButton(
                    controller: _.bottomSheetController,
                    children: [
                      "institutional".tr.capitalizeFirst!,
                      "Personal",
                      "illnes".tr.capitalizeFirst!,
                      "home_change".tr.capitalizeFirst!,
                      "parenting".tr.capitalizeFirst!,
                    ],
                    hint: "select_type".trParams({
                      'element': 'request'.tr,
                    }),
                    //initialSelection: true,
                    onSelect: _.selectForm,
                  ),
                  (_.bottomSheetController.id == null)
                      ? Container()
                      : (_.bottomSheetController.id == 0)
                          ? InstitutionalPermissionForm()
                          : OtherPermissionsForm()
                ],
              ),
            ),
            floatingActionButton: (_.bottomSheetController.id != null)
                ? FormSubmit(
                    isReady: _.formReady,
                    onClick: () {
                      print("ready");
                    },
                  )
                : null,
          );
        });
  }
}
