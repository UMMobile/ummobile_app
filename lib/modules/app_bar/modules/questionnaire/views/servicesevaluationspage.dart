import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:ummobile/modules/app_bar/modules/questionnaire/bindings/health_questionnaire_bindings.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';

import 'subpages/exercise_questionnaire/subpages/evaluationpage.dart';

class ServicesEvluationPage extends StatelessWidget {
  const ServicesEvluationPage({Key? key}) : super(key: key);

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
            leading: Icon(Icons.inventory_rounded),
            title: Text('evaluation services'.tr),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => Get.to(
              () => EvaluationPage(),
              transition: Transition.downToUp,
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
