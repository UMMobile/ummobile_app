import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/bindings/health_questionnaire_bindings.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/views/subpages/health_questionnaire/subpages/answered_page.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/views/subpages/responses_list/answered_page_scaffold.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/modules/login/controllers/questionnaire_response_controller.dart';
import 'package:ummobile/modules/tabs/modules/profile/models/user_credentials.dart';

import '../health_questionnaire/health_questionnaire.dart';

class HealthQuestionnaireResponses extends StatelessWidget {
  final LoginController _login = Get.find<LoginController>();

  HealthQuestionnaireResponses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UmAppBar(
        title: "responses".tr,
        showActionIcons: false,
      ),
      body: GetX<QuestionnaireResponseController>(
        init: QuestionnaireResponseController(),
        builder: (_) {
          if (_.isLoading.value)
            return Center(child: CircularProgressIndicator());
          return ListView(
            padding: EdgeInsets.all(20),
            children: _.answeredUsers
                .map((user) => TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        primary: Colors.white,
                      ),
                      onPressed: () async {
                        _login.activeUserId = user.userId;
                        Get.to(
                          () => QuestionnaireAnsweredScaffold(
                            currentAnswer: _.getUserResponse(user.userId)!,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                minRadius: 25,
                                maxRadius: 30,
                                backgroundImage: (user.image != null &&
                                        user.image!.isNotEmpty)
                                    ? MemoryImage(base64Decode(user.image!))
                                    : AssetImage('assets/img/default-img.jpg')
                                        as ImageProvider<Object>,
                              ),
                              title: Text(user.name),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                          Divider(height: 0),
                        ],
                      ),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
