import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/tabs/controllers/navigation_controller.dart';
import 'package:ummobile/modules/tabs/modules/forms/models/vacation.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/statics/utils.dart';

import 'page_request_vacations.dart';
import 'page_vacation_info.dart';

class VacationsPage extends StatefulWidget {
  @override
  _VacationsPageState createState() => _VacationsPageState();
}

class _VacationsPageState extends State<VacationsPage> {
  Card Function(Vacation vacation) _singleVacationsContext(
          BuildContext context) =>
      (Vacation vacation) {
        FontWeight weight;
        Color contentColor;
        Color borderColor = vacation.colorStatus;
        if (vacation.isInactive) {
          weight = FontWeight.normal;
          contentColor = Colors.grey;
        } else {
          weight = FontWeight.bold;
          contentColor = Theme.of(context).primaryColor;
        }

        return Card(
          child: ListTile(
            title: Text(
              '${ddmmYYYY(vacation.start)} - ${ddmmYYYY(vacation.end)}',
              style: TextStyle(fontWeight: weight, color: contentColor),
            ),
            trailing: Icon(
              Icons.navigate_next_rounded,
              color: contentColor,
            ),
            onTap: () => Get.to(() => VacationInfoPage(vacation: vacation)),
          ),
          shape: Border.all(width: 2, color: borderColor),
        );
      };

  @override
  Widget build(BuildContext context) {
    List<Card> vacationsItemsList({required List<Vacation> vacations}) {
      var single = _singleVacationsContext(context);
      vacations.sort((a, b) => b.start.compareTo(a.start));
      List<Card> vacationsCards = [];
      vacations.forEach((vacation) => vacationsCards.add(single(vacation)));
      return vacationsCards;
    }

    return Scaffold(
      appBar: UmAppBar(
        title: "vacations".tr.capitalizeFirst!,
      ),
      body: ListView(
        children: [
          ...vacationsItemsList(
            vacations: [
              Vacation(
                start: DateTime(2021, 07, 2),
                end: DateTime(2021, 07, 3),
              ),
              Vacation(
                start: DateTime(2021, 07, 2),
                end: DateTime(2021, 07, 3),
                approved: true,
              ),
              Vacation(
                start: DateTime(2021, 07, 2),
                end: DateTime(2021, 07, 3),
                approved: false,
              ),
              Vacation(
                start: DateTime(2021, 07, 1),
                end: DateTime(2021, 07, 2),
              ),
              Vacation(
                start: DateTime(2021, 07, 1),
                end: DateTime(2021, 07, 2),
                approved: true,
              ),
              Vacation(
                start: DateTime(2021, 07, 1),
                end: DateTime(2021, 07, 2),
                approved: false,
              ),
              Vacation(
                start: DateTime(2021, 06, 29),
                end: DateTime(2021, 06, 30),
              ),
              Vacation(
                start: DateTime(2021, 06, 29),
                end: DateTime(2021, 06, 30),
                approved: true,
              ),
              Vacation(
                start: DateTime(2021, 06, 29),
                end: DateTime(2021, 06, 30),
                approved: false,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () => Get.find<NavigationController>()
            .goToSubTabView(RequestVacationsPage(), context),
      ),
    );
  }
}
