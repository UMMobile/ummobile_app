import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/controllers/questionnaire_controller.dart';

class QuestionaireSendButton extends StatelessWidget {
  QuestionaireSendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<QuestionnaireController>(builder: (_) {
      return Container(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.secondary,
            minimumSize: Size(double.infinity, 40.0),
            disabledForegroundColor: Color.fromRGBO(255, 255, 255, 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(
            'ready'.tr.capitalizeFirst!,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: (_.questionnaireButtonNotifier.value)
              ? () => _.saveAnswer(_.questionnaireData)
              : null,
        ),
      );
    });
  }
}
