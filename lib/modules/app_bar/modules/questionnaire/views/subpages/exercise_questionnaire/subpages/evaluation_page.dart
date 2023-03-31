import 'package:flutter/material.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
/*import 'package:ummobile/modules/app_bar/modules/questionnaire/views/subpages/exercise_questionnair/evaluation.dart';*/

import 'package:ummobile/modules/app_bar/views/appBar.dart';

import '../widgets/evaluation.dart';

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({Key? key}) : super(key: key);

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UmAppBar(
        title: 'we wanna hear you'.tr.capitalizeFirst!,
        showActionIcons: false,
      ),
      body: QuestionsElements(),
    );
  }
}
