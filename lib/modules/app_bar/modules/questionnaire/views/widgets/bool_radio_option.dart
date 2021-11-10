import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/controllers/questionnaire_controller.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/models/covid_questionnaire_answer_form.dart';

class BoolRadioOption extends StatefulWidget {
  final String modelType;
  final bool? startValue;

  const BoolRadioOption({Key? key, required this.modelType, this.startValue})
      : super(key: key);

  @override
  _CuestionnaireRadioState createState() => _CuestionnaireRadioState();
}

class _CuestionnaireRadioState extends State<BoolRadioOption>
    with AutomaticKeepAliveClientMixin {
  final _questionaireController = Get.find<QuestionnaireController>();
  ChooseOptions? _chooseOptions;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _chooseOptions = (widget.startValue != null)
        ? (widget.startValue == true)
            ? ChooseOptions.yes
            : ChooseOptions.no
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            children: [
              Radio(
                value: ChooseOptions.yes,
                groupValue: _chooseOptions,
                onChanged: (ChooseOptions? value) {
                  setState(() {
                    _chooseOptions = value;
                    _questionaireController.radioSetState(
                        true, widget.modelType);
                  });
                },
              ),
              Text(
                'yes'.tr.capitalizeFirst!,
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          Row(
            children: [
              Radio(
                value: ChooseOptions.no,
                groupValue: _chooseOptions,
                onChanged: (ChooseOptions? value) {
                  setState(() {
                    _chooseOptions = value;
                    _questionaireController.radioSetState(
                        false, widget.modelType);
                  });
                },
              ),
              Text(
                'No',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
