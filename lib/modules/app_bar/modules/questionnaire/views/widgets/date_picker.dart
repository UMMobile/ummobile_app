import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/controllers/questionnaire_controller.dart';
import 'package:ummobile/statics/settings/colors.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class QuestionnaireDatePicker extends StatefulWidget {
  final int? type;
  final DateTime? startDate;
  final RecentContact? mapvalue;

  const QuestionnaireDatePicker(
      {Key? key, this.startDate, this.mapvalue, this.type})
      : super(key: key);

  @override
  _QuestionnaireDatePickerState createState() =>
      _QuestionnaireDatePickerState();
}

class _QuestionnaireDatePickerState extends State<QuestionnaireDatePicker> {
  final _questionnaireController = Get.find<QuestionnaireController>();
  DateTime? _dateTime;

  @override
  void initState() {
    switch (widget.type) {
      case 2:
        _dateTime =
            (widget.mapvalue!.when != null) ? widget.mapvalue!.when : null;
        break;

      default:
        _dateTime = (_questionnaireController
                    .questionnaireData.countries[widget.type!].date !=
                null)
            ? _questionnaireController
                .questionnaireData.countries[widget.type!].date
            : null;
    }
    super.initState();
  }

  String dateFormatter(String value) {
    List<String> strSplitted = value.split('/');
    return strSplitted[2] +
        '-' +
        strSplitted[1] +
        '-' +
        strSplitted[0] +
        ' 00:00:00';
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            foregroundColor: AppColorThemes.textColor,
            padding: EdgeInsets.symmetric(horizontal: 15.0)),
        onPressed: () => showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: (widget.startDate != null)
                        ? widget.startDate!
                        : DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day - 14),
                    lastDate: DateTime.now())
                .then((date) {
              if (date != null) {
                _dateTime = date;

                switch (widget.type) {
                  case 2:
                    widget.mapvalue!.when = _dateTime;
                    break;
                  default:
                    _questionnaireController.questionnaireData
                        .countries[widget.type!].date = _dateTime!;
                }
                _questionnaireController.enableQuestionnaireButton();
              }
              setState(() {});
            }),
        child: Row(
          children: <Widget>[
            Text('date'.tr.capitalizeFirst!),
            Expanded(child: SizedBox()),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Text((_dateTime == null)
                  ? ""
                  : DateFormat('dd MMM yyyy').format(_dateTime!).toString()),
            ),
            Icon(Icons.calendar_today, color: Get.theme.hintColor)
          ],
        ));
  }
}
