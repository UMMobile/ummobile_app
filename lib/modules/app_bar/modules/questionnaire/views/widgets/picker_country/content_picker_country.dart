import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/controllers/questionnaire_controller.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class CountryListView extends StatelessWidget {
  final ValueChanged<Country> onSelect;

  const CountryListView({
    Key? key,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        GetBuilder<QuestionnaireController>(builder: (_) {
          if (_.controllerCountries.isNotEmpty) {
            return Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: _.controllerCountries
                    .map<Widget>((country) => _listRow(country))
                    .toList(),
              ),
            );
          } else {
            return Expanded(
                child: Container(
              child: Text("Revisa tu conexion a internet"),
            ));
          }
        }),
      ],
    );
  }

  Widget _listRow(Country country) {
    return Material(
      // Add Material Widget with transparent color
      // so the ripple effect of InkWell will show on tap
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onSelect(country);
          Get.back();
        },
        child: Column(
          children: [
            Row(
              children: <Widget>[
                const SizedBox(width: 35),
                Expanded(
                  child:
                      Text(country.name, style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
            Divider(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
