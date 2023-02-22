import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/views/subpages/responses_list/user_responses_list.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/modules/login/controllers/questionnaire_response_controller.dart';
import 'package:ummobile/statics/Widgets/badge.dart' as badge;
import 'package:url_launcher/link.dart';

import 'widgets/widgets_export.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  @override
  void initState() {
    Get.put(LoginController(context));
    Get.put(QuestionnaireResponseController());
    Get.find<QuestionnaireResponseController>().refreshContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GradientBG(),
          ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              LoginLogo(),
              GetX<LoginController>(
                init: LoginController(context),
                builder: (_) {
                  if (_.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return (_.showQuickLogins.value)
                        ? LoginSessionsGrid()
                        : LoginFields();
                  }
                },
              )
            ],
          ),
          SafeArea(
            child: Container(
              child: Link(
                uri: Uri.parse('https://www.um.edu.mx/privacidad'),
                builder: (context, followLink) => GestureDetector(
                  onTap: followLink,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'privacy_policy'.tr.capitalizeFirst!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          GetX<QuestionnaireResponseController>(
              init: QuestionnaireResponseController(),
              builder: (_) {
                return Align(
                  alignment: Alignment.topRight,
                  child: Visibility(
                    visible: _.hasResponses.value,
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(8, kToolbarHeight, 8, 0),
                      child: FloatingActionButton(
                        child: badge.Badge(
                          top: -6,
                          right: -6,
                          value: _.responseCount.toString(),
                          child: Icon(
                            Icons.assignment,
                          ),
                        ),
                        elevation: 0,
                        highlightElevation: 0,
                        backgroundColor: Colors.transparent,
                        onPressed: () {
                          Get.to(() => HealthQuestionnaireResponses());
                        },
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
