import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/controllers/questionnaire_controller.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

import 'date_picker.dart';
import 'picker_country/picker_country.dart';

class QuestionaireCountryPicker extends StatefulWidget {
  final RecentCountry? countryController;
  final datetype;

  QuestionaireCountryPicker({Key? key, this.countryController, this.datetype})
      : super(key: key);

  @override
  _CuestionaireCountryPickerState createState() =>
      _CuestionaireCountryPickerState();
}

class _CuestionaireCountryPickerState extends State<QuestionaireCountryPicker> {
  String? countrySelected = "";
  late TextEditingController _ciudadController;

  @override
  void initState() {
    _ciudadController = TextEditingController();
    _ciudadController.text = widget.countryController!.city!;
    _ciudadController.addListener(_getLatestValue);

    if (widget.countryController!.country != null &&
        widget.countryController!.country!.isNotEmpty) {
      final searchId = int.parse(widget.countryController!.country!);
      final countries = Get.find<QuestionnaireController>().controllerCountries;
      final index = countries.indexWhere((element) => searchId == element.id);

      countrySelected = countries[index].name;
    }

    super.initState();
  }

  _getLatestValue() {
    widget.countryController!.city = _ciudadController.text;
    Get.find<QuestionnaireController>().enableQuestionnaireButton();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: Column(
        children: <Widget>[
          TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 15.0)),
              onPressed: () => showCountryPicker(
                    onSelect: (Country country) {
                      countrySelected = country.name;
                      widget.countryController!.country = country.id.toString();
                      Get.find<QuestionnaireController>()
                          .enableQuestionnaireButton();
                      setState(() {});
                    },
                  ),
              child: Row(
                children: <Widget>[
                  Text(
                    (countrySelected!.isEmpty)
                        ? 'country'.tr.capitalizeFirst!
                        : countrySelected!,
                    style: TextStyle(
                        color: (countrySelected!.isEmpty)
                            ? Theme.of(context).hintColor
                            : Theme.of(context).primaryColor),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_drop_down_sharp,
                    color: Colors.grey,
                  )
                ],
              )),
          TextField(
            controller: _ciudadController,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: 'city'.tr.capitalizeFirst!,
              hintStyle: TextStyle(color: Theme.of(context).hintColor),
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
          QuestionnaireDatePicker(
            type: widget.datetype,
          )
        ],
      ),
    );
  }
}
