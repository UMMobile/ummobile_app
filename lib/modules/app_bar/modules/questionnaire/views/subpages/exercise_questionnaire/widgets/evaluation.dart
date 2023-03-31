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

  @override
  void initState() {
    super.initState();
    // Llamamos a la función getArea() en UMMobileQuality y actualizamos el estado de countries con la respuesta de la API
    UMMobileQuality().getArea().then((areas) {
      if (areas != null) {
        setState(() {
          departamentos = areas;
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
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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

                print("Selected Country: $onChangedVal");
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
