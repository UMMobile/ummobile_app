import 'package:flutter/material.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/views/subpages/exercise_questionnaire/questions_page.dart';

import 'package:ummobile/modules/app_bar/views/appBar.dart';

class FormsView extends StatefulWidget {
  const FormsView({Key? key}) : super(key: key);

  @override
  State<FormsView> createState() => _FormsViewState();
}

class _FormsViewState extends State<FormsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UmAppBar(
        title: 'forms'.tr.capitalizeFirst!,
        showActionIcons: false,
      ),
      body: QuestionsPage(),
    );
  }
}
