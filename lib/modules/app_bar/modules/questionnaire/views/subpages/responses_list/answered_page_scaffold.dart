import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/views/subpages/health_questionnaire/subpages/answered_page.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/services/storage/questionnaire_responses/models/questionnaire_response.dart';

class QuestionnaireAnsweredScaffold extends StatelessWidget {
  final QuestionnaireResponse currentAnswer;

  const QuestionnaireAnsweredScaffold({
    Key? key,
    required this.currentAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UmAppBar(
          title: 'questionnaire'.tr.capitalizeFirst!,
          showActionIcons: false,
        ),
        body: QuestionnaireAnsweredPage(
          currentAnswer: currentAnswer,
        ));
  }
}
