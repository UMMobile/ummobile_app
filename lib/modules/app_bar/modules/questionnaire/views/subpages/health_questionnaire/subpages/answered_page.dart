import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/controllers/questionnaire_controller.dart';
import 'package:ummobile/modules/tabs/modules/profile/models/user_credentials.dart';

class QuestionnaireAnsweredPage extends StatelessWidget {
  const QuestionnaireAnsweredPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionnaireController>(
      builder: (_) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color.fromARGB(255, 04, 187, 199),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (_.currentAnswer.userImage.isNotEmpty)
                                ? MemoryImage(
                                    base64Decode(_.currentAnswer.userImage))
                                : AssetImage('assets/img/default-img.jpg')
                                    as ImageProvider<Object>,
                          ),
                        ),
                      ),
                      Text(
                        userId,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Divider(height: 24),
                      Text(
                        _.currentAnswer.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      if (userIsStudent)
                        Text(
                          _.currentAnswer.strResidence.tr,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      if (userIsEmployee)
                        Text(
                          _.currentAnswer.department,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      Text(
                        _.currentAnswer.strDateFilled,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Divider(height: 24),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image.memory(
                      Uint8List.fromList(_.currentAnswer.qr),
                      height: 200,
                    ),
                  ),
                  Divider(),
                  if (_.currentAnswer.strReason.tr.isNotEmpty) ...[
                    Text('${'reason'.tr.capitalizeFirst!}:'),
                    Text(
                      _.currentAnswer.strReason.tr,
                      textAlign: TextAlign.center,
                    ),
                  ] else ...[
                    Text(
                      "health_questionnaire_thanks".tr,
                      textAlign: TextAlign.center,
                    )
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
