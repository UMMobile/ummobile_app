import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import 'package:ummobile/modules/app_bar/modules/questionnaire/models/departments.dart';

import '../../../../controllers/ummobile_quaility.dart';

class QuestionsElements extends StatefulWidget {
  @override
  _QuestionsElementsState createState() => _QuestionsElementsState();
}

class _QuestionsElementsState extends State<QuestionsElements> {
  String? areaId;
  List<Areas> departamentos = [];

  String? preguntaId;
  List<Questions> preguntas = [];

  @override
  void initState() {
    super.initState();
    // Llamamos a la función getArea() en UMMobileQuality y actualizamos el estado de departamentos con la respuesta de la API
    UMMobileQuality().getArea().then((areas) {
      if (areas != null) {
        setState(() {
          departamentos = areas;
        });
      }
    });

    UMMobileQuality().getQuestions().then((result) {
      if (result != null) {
        setState(() {
          preguntas = result;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                'health_questionnaire_description'.tr,
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            /*ContainerUserInfo(
              title: 'credential'.tr.capitalizeFirst!,
              data: userId,
            ),*/
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child:
                  Text('select_department'.tr, style: TextStyle(fontSize: 16)),
            ),
            FormHelper.dropDownWidget(
              context,
              "select_department".tr,
              this.areaId,
              this
                  .departamentos
                  .map((area) => {"id": area.areaId, "label": area.nombre})
                  .toList(),
              (onChangedVal) {
                this.areaId = onChangedVal;

                print("selected_department: $onChangedVal");
              },
              (onValidateVal) {
                if (onValidateVal == null) {
                  return 'select_department';
                }
                return null;
              },
              borderColor: Theme.of(context).primaryColor,
              borderFocusColor: Theme.of(context).primaryColor,
              borderRadius: 5,
              optionValue: "id",
              optionLabel: "label",
            ),
          ],
        ),
      ),
    );
  }
}
