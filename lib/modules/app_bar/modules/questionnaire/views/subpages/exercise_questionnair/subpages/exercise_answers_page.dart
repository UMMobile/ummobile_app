import 'package:flutter/material.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/views/subpages/exercise_questionnair/questions_page.dart';

import 'package:ummobile/modules/app_bar/views/appBar.dart';

class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
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
