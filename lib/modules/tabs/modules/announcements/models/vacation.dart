import 'package:flutter/material.dart';

class Vacation {
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

  Vacation({required this.start, required this.end, this.approved});
}
