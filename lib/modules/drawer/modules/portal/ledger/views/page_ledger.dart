import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/modules/drawer/modules/portal/ledger/controllers/balances_controller.dart';
import 'package:ummobile/modules/drawer/modules/portal/ledger/controllers/movements_controller.dart';
import 'package:ummobile/modules/drawer/modules/portal/ledger/views/widgets/balance_floating_button.dart';
import 'package:ummobile/modules/drawer/modules/portal/ledger/views/widgets/section_movements.dart';
import 'package:ummobile/statics/widgets/shimmers.dart';

import 'widgets/table_header.dart';

class LedgerPage extends GetView<MovementsController> {
  LedgerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UmAppBar(
        title: 'ledger'.tr.capitalizeFirst!,
        showActionIcons: false,
      ),
      body: controller.obx(
        (movements) => RefreshIndicator(
          onRefresh: () async {
            Get.find<BalancesController>().refreshContent();
          },
          child: Column(
            children: <Widget>[
              TableHeader(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: movements!
                      .map(
                        (section) => MovementsSection(
                          header: section.title,
                          movements: section.movements,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        onEmpty: (controller.balanceSelectable)
            ? Center(child: Text('unselected_balance'.tr.capitalizeFirst!))
            : Center(child: Text('empty_movements'.tr)),
        onLoading: _LedgerShimmer(),
        onError: (e) => controller.internetPage(e),
      ),
      floatingActionButton: BalanceFloatingButton(),
    );
  }
}

class _LedgerShimmer extends StatelessWidget {
  const _LedgerShimmer({Key? key}) : super(key: key);

  Widget _shimmerSection() {
    final rand = 1 + Random().nextInt(4 - 1);

    List<Widget> movements = List.empty(growable: true);

    for (int i = 0; i < rand; i++) {
      movements.add(
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: RectShimmer(
            height: 75,
            radius: 10,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 210, 15),
            child: RectShimmer(height: 30),
          ),
          ...movements,
        ],
      ),
    );
  }

  _shimmerSectionList() {
    List<Widget> list = List.empty(growable: true);
    for (int i = 0; i < 10; i++) {
      list.add(_shimmerSection());
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        RectShimmer(
          height: 150,
          bottom: 20,
          radius: 12,
          left: 6,
          right: 6,
        ),
        ..._shimmerSectionList(),
      ],
    );
  }
}
