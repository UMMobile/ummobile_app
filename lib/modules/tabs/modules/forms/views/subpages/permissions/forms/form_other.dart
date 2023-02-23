//import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/tabs/modules/forms/controllers/permissions_controller.dart';
import 'package:ummobile/statics/Widgets/form/date_picker.dart';
import 'package:ummobile/statics/Widgets/form/switch.dart';
import 'package:ummobile/statics/Widgets/form/text_field.dart';

class OtherPermissionsForm extends StatefulWidget {
  @override
  _OtherPermissionsFormState createState() => _OtherPermissionsFormState();
}

class _OtherPermissionsFormState extends State<OtherPermissionsForm> {
  DateTime? startDate;
  bool travelOutsideMexico = false;

  final TextEditingController daysController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController observationsController = TextEditingController();

  void get isReady {
    // text fields validation goes here
    bool textFieldsNotReady = (this.observationsController.text.isEmpty);
    var controller = Get.find<PermissionsController>();
    if (this.startDate == null || textFieldsNotReady) {
      controller.formIsReady(false);
    } else {
      controller.formIsReady(true);
    }
  }

  String _ddmmYYYY(DateTime date) =>
      date.toString().split(' ')[0].split('-').reversed.join('/');

  @override
  void initState() {
    this.observationsController.addListener(() => setState(() => this.isReady));
    this.daysController.addListener(() => setState(() {
          if (daysController.text.isEmpty) startDate = null;
          this.isReady;
        }));
    super.initState();
  }

  @override
  void dispose() {
    this.phoneController.dispose();
    this.observationsController.dispose();
    this.daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    phoneController.text = '9371416701';
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          UMTextField(
            controller: daysController,
            label: 'Días Permitidos',
            textInputType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            verticalDirection: VerticalDirection.up,
            children: [
              UMDatePicker(
                label: 'Fecha inicial',
                enable: daysController.text.isNotEmpty,
                onSelect: (date) {
                  if (date == null) return;
                  setState(() {
                    this.startDate = date;
                    this.isReady;
                  });
                },
                selected: startDate != null ? _ddmmYYYY(startDate!) : null,
              ),
              UMDatePicker(
                label: 'Fecha final',
                enable: false,
                initialDate: startDate,
                selected: startDate != null && daysController.text.isNotEmpty
                    ? _ddmmYYYY(
                        startDate!.add(
                          Duration(days: int.parse(daysController.text)),
                        ),
                      )
                    : null,
              ),
            ],
          ),
          Divider(),
          UMSwitch(
            label: 'Travel outside Mexico',
            value: this.travelOutsideMexico,
            onChanged: (value) {
              setState(() {
                this.travelOutsideMexico = value;
              });
            },
          ),
          Visibility(
            visible: this.travelOutsideMexico,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Stop!',
                    style: TextStyle(
                      color: Get.theme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text: ' To travel outside Mexico frontiers, you ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Get.theme.primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: 'MUST',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.primaryColor,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' buy a travel insurance. Whithout the insurance, the institution it is not responsible for any accident during your vacation time!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Get.theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 30,
            thickness: 1.0,
          ),
          UMTextField(
              label: 'Phone', enable: false, controller: phoneController),
          UMTextField(
            label: 'Observaciones',
            linesHeigth: 5,
            controller: observationsController,
          ),
        ],
      ),
    );
  }
}
