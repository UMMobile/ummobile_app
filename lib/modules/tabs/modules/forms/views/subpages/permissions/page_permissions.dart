import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/tabs/controllers/navigation_controller.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';

import 'page_permissions_info.dart';
import 'page_request_permission.dart';

class Permission {
  DateTime start;
  DateTime end;
  bool? approved;

  bool get startBeforeNow => this.start.isBefore(DateTime.now());
  bool get endAfterNow => this.end.isAfter(DateTime.now());

  bool get isCurrent => this.startBeforeNow && this.endAfterNow;
  bool get isInactive =>
      (this.startBeforeNow && !this.endAfterNow) ||
      (this.isCurrent && this.approved != null && this.approved == false);
  bool get isWaiting => !this.startBeforeNow && this.approved == null;
  bool get isApproved => this.approved != null ? this.approved! : false;

  Color get colorStatus {
    if (this.isInactive) {
      return Colors.grey;
    } else {
      if (this.isCurrent) {
        if (this.isApproved) {
          // Is already on the date range and is approved.
          // The employee is on vacations.
          return Colors.blue;
        } else if (this.approved == null) {
          // Is already on the date range but is no confirmed by the administrators.
          // The employee is not on vacations but maybe can be approved on that date, idk.
          return Colors.orange;
        } else {
          // Is already on the date range but is not approved.
          // The solicitude is marked as inactive.
          return Colors.grey;
        }
      } else if (this.isWaiting) {
        // The employee is waiting for the vacations approval.
        return Colors.yellow;
      } else if (this.isApproved) {
        // The vacations are approved.
        return Colors.green;
      } else {
        // The vacations are not approved.
        return Colors.red;
      }
    }
  }

  Permission({required this.start, required this.end, this.approved});
}

class PermissionsPage extends StatefulWidget {
  @override
  _PermissionsPageState createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  @override
  void initState() {
    super.initState();
  }

  String _ddmmYYYY(DateTime date) =>
      date.toString().split(' ')[0].split('-').reversed.join('/');

  Card Function(Permission permission) _singleVacationsContext(
          BuildContext context) =>
      (Permission permission) {
        FontWeight weight;
        Color contentColor;
        Color borderColor = permission.colorStatus;
        if (permission.isInactive) {
          weight = FontWeight.normal;
          contentColor = Colors.grey;
        } else {
          weight = FontWeight.bold;
          contentColor = Theme.of(context).primaryColor;
        }

        return Card(
          child: ListTile(
            title: Text(
              '${_ddmmYYYY(permission.start)} - ${_ddmmYYYY(permission.end)}',
              style: TextStyle(fontWeight: weight, color: contentColor),
            ),
            trailing: Icon(
              Icons.navigate_next_rounded,
              color: contentColor,
            ),
            onTap: () =>
                Get.to(() => PermissionInfoPage(permision: permission)),
          ),
          shape: Border.all(width: 2, color: borderColor),
        );
      };

  @override
  Widget build(BuildContext context) {
    List<Card> vacationsItemsList({required List<Permission> vacations}) {
      var single = _singleVacationsContext(context);
      vacations.sort((a, b) => b.start.compareTo(a.start));
      List<Card> vacationsCards = [];
      vacations.forEach((vacation) => vacationsCards.add(single(vacation)));
      return vacationsCards;
    }

    return Scaffold(
      appBar: UmAppBar(
        title: "permissions".tr.capitalizeFirst!,
      ),
      body: ListView(
        children: [
          ...vacationsItemsList(
            vacations: [
              Permission(
                start: DateTime(2021, 07, 2),
                end: DateTime(2021, 07, 3),
              ),
              Permission(
                start: DateTime(2021, 07, 2),
                end: DateTime(2021, 07, 3),
                approved: true,
              ),
              Permission(
                start: DateTime(2021, 07, 2),
                end: DateTime(2021, 07, 3),
                approved: false,
              ),
              Permission(
                start: DateTime(2021, 07, 1),
                end: DateTime(2021, 07, 2),
              ),
              Permission(
                start: DateTime(2021, 07, 1),
                end: DateTime(2021, 07, 2),
                approved: true,
              ),
              Permission(
                start: DateTime(2021, 07, 1),
                end: DateTime(2021, 07, 2),
                approved: false,
              ),
              Permission(
                start: DateTime(2021, 06, 29),
                end: DateTime(2021, 06, 30),
              ),
              Permission(
                start: DateTime(2021, 06, 29),
                end: DateTime(2021, 06, 30),
                approved: true,
              ),
              Permission(
                start: DateTime(2021, 06, 29),
                end: DateTime(2021, 06, 30),
                approved: false,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () => Get.to(RequestPermissionsPage()),
      ),
    );
  }
}
