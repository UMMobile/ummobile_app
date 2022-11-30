import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:ummobile/modules/app_bar/modules/questionnaire/bindings/health_questionnaire_bindings.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';

import 'subpages/exercise_questionnair/subpages/exercise_answers_page.dart';

class QuestionnairesPage extends StatelessWidget {
  const QuestionnairesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UmAppBar(
        title: 'forms'.tr.capitalizeFirst!,
        showActionIcons: false,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.directions_run_rounded),
            title: Text('health_questionnaire'.tr),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => Get.to(
              () => WebViewApp(),
              transition: Transition.downToUp,
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
