//import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/tabs/modules/forms/views/widgets/submit_button.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/statics/Widgets/form/date_picker.dart';
import 'package:ummobile/statics/Widgets/form/switch.dart';
import 'package:ummobile/statics/Widgets/form/text_field.dart';
import 'package:ummobile/statics/utils.dart';

class RequestVacationsPage extends StatefulWidget {
  @override
  _RequestVacationsPageState createState() => _RequestVacationsPageState();
}

class _RequestVacationsPageState extends State<RequestVacationsPage>
    with SingleTickerProviderStateMixin {
  DateTime? startDate;
  DateTime? endDate;
  bool primaVacacional = false;
  bool internationalTravel = false;
  bool visitParents = false;
  final TextEditingController placeController = TextEditingController();
  final TextEditingController kmController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool get isReady {
    // text fields validation goes here
    bool textFieldsNotReady = (this.visitParents &&
            (this.placeController.text.isEmpty ||
                this.kmController.text.isEmpty)) ||
        this.descriptionController.text.isEmpty;

    if (this.startDate == null ||
        this.endDate == null ||
        this.daysSelected <= 0 ||
        textFieldsNotReady) {
      return false;
    } else {
      return true;
    }
  }

  int get daysSelected {
    if (this.startDate == null || this.endDate == null) {
      return 0;
    } else {
      return this.endDate!.difference(this.startDate!).inDays;
    }
  }

  @override
  void initState() {
    this.placeController.addListener(() => setState(() {}));
    this.kmController.addListener(() => setState(() {}));
    this.descriptionController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    this.placeController.dispose();
    this.kmController.dispose();
    this.phoneController.dispose();
    this.emailController.dispose();
    this.descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int allowedDays = 14;

    phoneController.text = '9371416701';
    emailController.text = 'jonicgp97@gmail.com';

    return Scaffold(
      appBar: UmAppBar(
        title: "request_verb".trParams({
          'element': "vacation".tr,
        }).capitalizeFirst!,
      ),
      body: Container(
        padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
        child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    verticalDirection: VerticalDirection.up,
                    children: [
                      UMDatePicker(
                        label: 'initial_date'.tr.capitalizeFirst,
                        onSelect: (date) {
                          if (date == null) return;
                          setState(() {
                            this.startDate = date;
                            if (this.endDate != null) {
                              Duration difference =
                                  this.endDate!.difference(date);
                              if (difference.inDays >= allowedDays ||
                                  difference.inDays <= 0) {
                                this.endDate = null;
                              }
                            }
                          });
                        },
                        selected:
                            startDate != null ? ddmmYYYY(startDate!) : null,
                      ),
                      UMDatePicker(
                        label: 'final_date'.tr.capitalizeFirst,
                        enable: startDate != null,
                        initialDate: startDate,
                        limitDays: allowedDays,
                        onSelect: (date) => setState(
                          () => endDate = date ?? endDate,
                        ),
                        selected: endDate != null ? ddmmYYYY(endDate!) : null,
                      ),
                    ],
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    UMSwitch(
                      label: 'vacation_bonus'.tr,
                      value: this.primaVacacional,
                      onChanged: (value) {
                        setState(() {
                          this.primaVacacional = value;
                        });
                      },
                    ),
                    UMSwitch(
                      label: 'international_travel'.tr,
                      value: this.internationalTravel,
                      onChanged: (value) {
                        setState(() {
                          this.internationalTravel = value;
                        });
                      },
                    ),
                  ],
                ),
                UMSwitch(
                  label: 'visit_parents'.tr,
                  value: this.visitParents,
                  onChanged: (value) {
                    setState(() {
                      this.visitParents = value;
                    });

                    if (!value) {
                      // Clean the visit parents fields
                      this.placeController.text = '';
                      this.kmController.text = '';
                    }
                  },
                ),
                Visibility(
                  visible: this.internationalTravel,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Get.theme.primaryColor),
                      children: _internationalWarning(
                          'international_vacation_warning'.tr),
                    ),
                  ),
                ),
                Divider(),
                Visibility(
                  visible: this.visitParents,
                  child: UMTextField(
                    label: 'place'.tr.capitalizeFirst!,
                    textInputType: TextInputType.streetAddress,
                    controller: placeController,
                  ),
                  maintainAnimation: false,
                ),
                Visibility(
                  visible: this.visitParents,
                  child: UMTextField(
                    label: 'kilometers'.tr.capitalizeFirst!,
                    textInputType: TextInputType.phone,
                    controller: kmController,
                  ),
                  maintainAnimation: false,
                ),
                UMTextField(
                    label: 'cellphone'.tr.capitalizeFirst!,
                    enable: false,
                    controller: phoneController),
                UMTextField(
                    label: 'email'.tr.capitalizeFirst!,
                    enable: false,
                    controller: emailController),
                UMTextField(
                  label: 'traveling_description'.tr,
                  linesHeigth: 5,
                  controller: descriptionController,
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 38,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(10))),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: daysSelected.toString(),
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      TextSpan(
                        text:
                            '  ${daysSelected != 1 ? 'días seleccionados' : 'día seleccionado'} de  ',
                        style: TextStyle(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: allowedDays.toString(),
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FormSubmit(
        isReady: this.isReady,
        onClick: () {},
      ),
    );
  }

  List<TextSpan> _internationalWarning(String warning) {
    if (Get.locale == Locale('en_US')) {
      return [
        TextSpan(
          text: warning.substring(0, 5),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: warning.substring(5, 46),
        ),
        TextSpan(
          text: warning.substring(46, 50),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: warning.substring(50),
        ),
      ];
    }
    return [
      TextSpan(
        text: warning.substring(0, 6),
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: warning.substring(6, 54),
      ),
      TextSpan(
        text: warning.substring(54, 59),
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: warning.substring(59),
      ),
    ];
  }
}
