import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/controllers/questionnaire_controller.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/views/widgets/widgets_export.dart';
import 'package:ummobile/modules/tabs/modules/profile/models/user_credentials.dart';
import 'package:ummobile/statics/Widgets/form/yes_or_no.dart';
import 'package:ummobile/statics/settings/colors.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class QuestionnaireUnAnsweredPage extends StatelessWidget {
  QuestionnaireUnAnsweredPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _questionaireController = Get.find<QuestionnaireController>();

    /// * Method that returns a widget for text instructions
    Widget text(double spacing, String value, {bool isRequired: false}) {
      return Container(
        margin: EdgeInsets.only(bottom: spacing),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColorThemes.textColor,
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    /// * Method that returns a widget with user information
    _infoRow(String name, String surname) {
      return Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: ContainerUserInfo(
              title: 'name'.tr.capitalizeFirst!,
              data: name,
            ),
          ),
          Flexible(
            flex: 1,
            child: ContainerUserInfo(
              title: 'surname'.tr.capitalizeFirst!,
              data: surname,
            ),
          )
        ],
      );
    }

    /// * Posible hidden data depending on the value of a radio
    final dateContact = Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: <Widget>[
          text(
            10,
            '4. ${'health_questionnaire_question_when_contact'.tr}',
            isRequired: true,
          ),
          QuestionnaireDatePicker(
            type: 2,
            startDate: DateTime(2019),
            mapvalue: _questionaireController.questionnaireData.recentContact,
          ),
          Divider(
            height: 0,
            color: Colors.grey,
            thickness: 1,
          )
        ],
      ),
    );

    Widget _travelSectionWidget() {
      if (_questionaireController.hasTravel.value) {
        if (_questionaireController.questionnaireData.countries.length < 2)
          _questionaireController.questionnaireData.countries = [
            RecentCountry(country: null, city: ""),
            RecentCountry(country: null, city: ""),
          ];

        return Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: <Widget>[
              text(20, '2. ${'health_questionnaire_question_where_travel'.tr}',
                  isRequired: true),
              QuestionaireCountryPicker(
                countryController:
                    _questionaireController.questionnaireData.countries[0],
                datetype: 0,
              ),
              QuestionaireCountryPicker(
                countryController:
                    _questionaireController.questionnaireData.countries[1],
                datetype: 1,
              ),
            ],
          ),
        );
      } else {
        _questionaireController.questionnaireData.countries = [];
        return Container();
      }
    }

    /// * Method that displays a true false quesion block
    Widget radioTile(
        String incise, String symptom, String modelType, bool? model) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(flex: 1, child: Text(incise)),
              Expanded(flex: 12, child: Text(symptom)),
            ],
          ),
          BoolRadioOption(
            modelType: modelType,
            //startValue: model,
          ),
          Divider(
            height: 4,
            color: Colors.grey,
            thickness: 1,
          )
        ]),
      );
    }

    return Obx(
      () {
        return ListView(
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: false,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: <Widget>[
            TextButton(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.open_in_browser, size: 18),
                      Text(' ${'source'.tr}'),
                    ],
                  ),
                  Text(
                      'Definición Operacional de Caso Sospechoso de Enfermedad Respiratoria Viral'),
                ],
              ),
              onPressed: () async {
                await launch(
                    'https://www.gob.mx/cms/uploads/attachment/file/573732/Comunicado_Oficial_DOC_sospechoso_ERV_240820.pdf',
                    customTabsOption: CustomTabsOption(
                      toolbarColor: Theme.of(context).colorScheme.secondary,
                      enableDefaultShare: true,
                      enableUrlBarHiding: true,
                      showPageTitle: true,
                      extraCustomTabs: const <String>[
                        // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
                        'org.mozilla.firefox',
                        // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
                        'com.microsoft.emmx',
                      ],
                    ));
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                'health_questionnaire_description'.tr,
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            ContainerUserInfo(
              title: 'credential'.tr.capitalizeFirst!,
              data: userId,
            ),
            text(
                20,
                'health_questionnaire_greeting'.trParams({
                  'role': _questionaireController.user!.role.toString().tr,
                })),
            _infoRow(_questionaireController.user!.name,
                _questionaireController.user!.surnames),
            ContainerUserInfo(
              title: 'email'.tr.capitalizeFirst!,
              data: _questionaireController.user!.extras.email,
            ),
            ContainerUserInfo(
              title: 'cellphone'.tr.capitalizeFirst!,
              data: _questionaireController.user!.extras.phone ?? '',
            ),
            text(
              20,
              '1. ${'health_questionnaire_question_has_travel'.tr}',
              isRequired: true,
            ),
            UMYesOrNo(
              keepAlive: true,
              extend: true,
              onChanged: (value) {
                _questionaireController.hasTravel.value =
                    value == YesOrNoOptions.yes ? true : false;
                if (!_questionaireController.travelWasSelected.value) {
                  _questionaireController.travelWasSelected.value = true;
                }
                _questionaireController.enableQuestionnaireButton();
              },
            ),
            _travelSectionWidget(),
            text(
              5,
              '3. ${'health_questionnaire_question_has_contact'.tr}',
              isRequired: true,
            ),
            BoolRadioOption(
              modelType: "contact",
              /*startValue:
                  _questionaireController.questionnaireData.recentContact.yes,*/
            ),
            (_questionaireController.contact.value) ? dateContact : Container(),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                'questionnaire_instructions'.tr,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            text(5, '5. ${'health_questionnaire_question_major_symptoms'.tr}',
                isRequired: true),
            Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Column(children: <Widget>[
                  radioTile(
                      "a)",
                      'fever'.tr.capitalizeFirst!,
                      "fever",
                      _questionaireController
                          .questionnaireData.majorSymptoms["fever"]),
                  radioTile(
                      "b)",
                      'frequent_cough'.tr.capitalizeFirst!,
                      "Freqcough",
                      _questionaireController.questionnaireData
                          .majorSymptoms["frequenteCoughing"]),
                  radioTile(
                      "c)",
                      'headache'.tr.capitalizeFirst!,
                      "headache",
                      _questionaireController
                          .questionnaireData.majorSymptoms["headache"]),
                  radioTile(
                      "d)",
                      'difficulty_breathing'.tr.capitalizeFirst!,
                      "diffbrth",
                      _questionaireController.questionnaireData
                          .majorSymptoms["difficultyBreating"])
                ])),
            text(5, '6. ${'health_questionnaire_question_minor_symptoms'.tr}',
                isRequired: true),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: Column(
                children: <Widget>[
                  radioTile(
                      "a)",
                      'sore_throat'.tr.capitalizeFirst!,
                      "sorthrt",
                      _questionaireController
                          .questionnaireData.minorSymptoms["soreThorat"]),
                  radioTile(
                      "b)",
                      'runny_nose'.tr.capitalizeFirst!,
                      "runnse",
                      _questionaireController
                          .questionnaireData.minorSymptoms["runnyNose"]),
                  radioTile(
                      "c)",
                      'loss_of_smell'.tr.capitalizeFirst!,
                      "lssml",
                      _questionaireController
                          .questionnaireData.minorSymptoms["looseSmell"]),
                  radioTile(
                      "d)",
                      'loss_of_taste'.tr.capitalizeFirst!,
                      "lstst",
                      _questionaireController
                          .questionnaireData.minorSymptoms["looseOfTaste"]),
                  radioTile(
                      "e)",
                      'body_pain'.tr.capitalizeFirst!,
                      "bdpn",
                      _questionaireController
                          .questionnaireData.minorSymptoms["bodyPain"]),
                  radioTile(
                      "f)",
                      'joint_pain'.tr.capitalizeFirst!,
                      "jntpn",
                      _questionaireController
                          .questionnaireData.minorSymptoms["jointPain"]),
                  radioTile(
                      "g)",
                      'eye_discharge'.tr.capitalizeFirst!,
                      "ydschrg",
                      _questionaireController
                          .questionnaireData.minorSymptoms["eyeDischarge"]),
                  radioTile(
                      "h)",
                      'diarrhea'.tr.capitalizeFirst!,
                      "drrh",
                      _questionaireController
                          .questionnaireData.minorSymptoms["diarrhea"]),
                  radioTile(
                      "i)",
                      'vomiting'.tr.capitalizeFirst!,
                      "vmtng",
                      _questionaireController
                          .questionnaireData.minorSymptoms["vomiting"]),
                  radioTile(
                      "j)",
                      'chest_pain'.tr.capitalizeFirst!,
                      "chstpn",
                      _questionaireController
                          .questionnaireData.minorSymptoms["chestPain"]),
                ],
              ),
            ),
            QuestionaireSendButton(),
          ],
        );
      },
    );
  }
}
