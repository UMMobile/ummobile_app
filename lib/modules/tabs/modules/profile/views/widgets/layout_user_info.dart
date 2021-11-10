import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ummobile/modules/tabs/modules/profile/utils/data_conversors.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

import 'row_user_info.dart';

class UserInfo extends StatelessWidget {
  final User user;
  final _controller = PageController();

  UserInfo({
    required this.user,
  });

  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 30.0),
          child: SmoothPageIndicator(
            controller: _controller,
            count: _countPages(),
            effect: WormEffect(
                activeDotColor: Theme.of(context).colorScheme.secondary,
                dotHeight: 12,
                dotWidth: 12),
          ),
        ),
        Container(
          height: 300,
          child: PageView(
            controller: _controller,
            physics: BouncingScrollPhysics(),
            children: _getPages(),
          ),
        ),
      ],
    );
  }

  int _countPages() {
    int count = 0;
    if (user.isStudent) {
      count++;
      if (user.student!.academic != null) count++;
      if (user.student!.scholarship != null) count++;
    } else if (user.isEmployee) {
      count = 2;
    }
    return count;
  }

  List<Widget> _getPages() {
    List<Widget> returnable = List.empty(growable: true);
    if (user.isStudent) {
      var data = user.student!;
      returnable.add(
        Column(
          children: <Widget>[
            RowUserInfo(
              title: 'baptized'.tr.capitalizeFirst,
              data: boolToString(data.baptized),
            ),
            RowUserInfo(title: 'Curp', data: user.extras.curp),
            RowUserInfo(
                title: 'email'.tr.capitalizeFirst, data: user.extras.email),
            RowUserInfo(
              title: 'marital_status'.tr.capitalizeFirst,
              data: user.extras.maritalStatus,
            ),
            RowUserInfo(
                title: 'birth_date'.tr.capitalizeFirst,
                data: DateFormat('yyyy-MM-dd').format(user.extras.birthday)),
            RowUserInfo(
                title: 'religion'.tr.capitalizeFirst, data: data.religion),
            RowUserInfo(
                title: 'student_type'.tr.capitalizeFirst, data: data.type),
          ],
        ),
      );
      if (user.student!.academic != null)
        returnable.add(
          Column(
            children: <Widget>[
              RowUserInfo(
                  title: 'dorm'.tr.capitalizeFirst,
                  data: data.academic!.dormitory.toString()),
              RowUserInfo(
                title: 'enrolled'.tr.capitalizeFirst,
                data: boolToString(data.academic!.signedUp),
              ),
              RowUserInfo(
                  title: 'modality'.tr.capitalizeFirst,
                  data: data.academic!.modality),
              RowUserInfo(
                title: 'residence'.tr.capitalizeFirst,
                data: data.academic!.residence.toString().split(".").last,
                //data: Residence.values[0].toString(),
              )
            ],
          ),
        );
      if (user.student!.scholarship != null)
        returnable.add(Column(
          children: <Widget>[
            RowUserInfo(
                title: 'status'.tr.capitalizeFirst,
                data: data.scholarship!.status),
            RowUserInfo(
                title: 'agreement_hours'.tr.capitalizeFirst,
                data: data.scholarship!.hours.toString()),
            RowUserInfo(
                title: 'place'.tr.capitalizeFirst,
                data: data.scholarship!.workplace),
            RowUserInfo(
                title: 'position'.tr.capitalizeFirst,
                data: data.scholarship!.position),
          ],
        ));
    } else if (user.isEmployee) {
      var data = user.employee!;
      returnable.add(
        Column(
          children: <Widget>[
            RowUserInfo(
              title: 'birth_date'.tr.capitalizeFirst,
              data: DateFormat('yyyy-MM-dd').format(user.extras.birthday),
            ),
            RowUserInfo(title: 'CURP', data: user.extras.curp),
            RowUserInfo(title: 'IMSS', data: data.imss),
            RowUserInfo(title: 'RFC', data: data.rfc),
            RowUserInfo(
              title: 'marital_status'.tr.capitalizeFirst,
              data: user.extras.maritalStatus,
            ),
            RowUserInfo(
              title: 'email'.tr.capitalizeFirst,
              data: user.extras.email,
            ),
            RowUserInfo(
              title: 'cellphone'.tr.capitalizeFirst,
              data: user.extras.phone,
            ),
          ],
        ),
      );

      returnable.add(
        Column(
          children: <Widget>[
            RowUserInfo(
              title: 'contract_type'.tr,
              data: data.contract.toString().tr,
            ),
            RowUserInfo(
              title: 'positions'.tr,
              titleAlign: TextAlign.center,
            ),
            if (data.positions.isEmpty)
              RowUserInfo(
                data: 'no_positions'.tr,
                valueAlign: TextAlign.center,
              ),
            ...this._mapAllPosition(data.positions),
          ],
        ),
      );
    }

    return returnable;
  }

  List<RowUserInfo> _mapAllPosition(List<Position> positions) {
    List<RowUserInfo> rows = [];
    positions.forEach((position) {
      rows.addAll(this._mapSinglePosition(position));
    });
    return rows;
  }

  List<RowUserInfo> _mapSinglePosition(Position position) {
    return [
      RowUserInfo(
        title: position.department,
        titleAlign: TextAlign.end,
      ),
      RowUserInfo(
        data: position.name != null && position.name!.isNotEmpty
            ? position.name!
            : '-',
      ),
    ];
  }
}
