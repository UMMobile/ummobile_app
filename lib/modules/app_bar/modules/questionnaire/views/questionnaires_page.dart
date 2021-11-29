import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/bindings/health_questionnaire_bindings.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/modules/tabs/modules/profile/models/user_credentials.dart';

import 'subpages/health_questionnaire/health_questionnaire.dart';

class QuestionnairesPage extends StatelessWidget {
  const QuestionnairesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UmAppBar(
        title: 'questionnaire'.tr.capitalizeFirst!,
        showActionIcons: false,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.health_and_safety),
            title: Text('health_questionnaire'.tr),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => Get.to(
              () => HealthQuestionnaire(),
              transition: Transition.downToUp,
              binding: HealthQuestionnaireBinding(),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
