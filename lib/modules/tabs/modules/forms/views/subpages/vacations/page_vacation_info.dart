import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/tabs/modules/forms/models/vacation.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';

class VacationInfoPage extends StatelessWidget {
  final Vacation vacation;

  VacationInfoPage({required this.vacation});

  @override
  Widget build(BuildContext context) {
    final String pageName = 'information_female'.trParams({
      'element': 'vacation'.tr,
    }).capitalizeFirst!;
    return Scaffold(
      appBar: UmAppBar(
        title: pageName,
        showActionIcons: false,
      ),
      body: Container(
          child: ListView(
        children: [
          Text(pageName),
          Wrap(
            children: [
              Text(vacation.start.toString()),
              Text(vacation.end.toString()),
            ],
          )
        ],
      )),
    );
  }
}
