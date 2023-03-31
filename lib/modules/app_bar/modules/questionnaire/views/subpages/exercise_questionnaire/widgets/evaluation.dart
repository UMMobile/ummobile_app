import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class QuestionsElements extends StatefulWidget {
  @override
  _QuestionsElementsState createState() => _QuestionsElementsState();
}

class _QuestionsElementsState extends State<QuestionsElements> {
  String? countryId;
  List<dynamic> countries = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.countries.add({"id": 1, "label": "firts"});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            FormHelper.dropDownWidget(
              context,
              "Select Country",
              this.countryId,
              this.countries,
              (onChangedVal) {
                this.countryId = onChangedVal;

                print("Selected Country: $onChangedVal");
              },
              (onValidateVal) {
                if (onValidateVal == null) {
                  return 'Please Select Country';
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
