import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/modules/drawer/modules/portal/ledger/controllers/movements_controller.dart';
import 'package:ummobile/modules/drawer/modules/portal/ledger/views/widgets/balance_floating_button.dart';
import 'package:ummobile/modules/drawer/modules/portal/ledger/views/widgets/section_movements.dart';
import 'package:ummobile/statics/widgets/shimmers.dart';

import 'widgets/table_header.dart';

class LedgerPage extends GetView<MovementsController> {
  LedgerPage({Key? key}) : super(key: key);

  final dataColumStyle =
      TextStyle(color: Colors.white, fontStyle: FontStyle.italic);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UmAppBar(
        title: 'ledger'.tr.capitalizeFirst!,
        showActionIcons: false,
      ),
      body: controller.obx(
        (movements) => Column(
          children: <Widget>[
            TableHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20),
                children: movements!
                    .map(
                      (e) => MovementsSection(
                        header: e.date,
                        movements: e.movements,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
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

  Widget _shimmerRow() {
    final rand = Random();
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RectShimmer(
            height: (24 + rand.nextInt(48 - 24)).toDouble(),
            width: 64,
          ),
          RectShimmer(
            height: 24,
            width: 50,
          ),
          RectShimmer(
            height: 24,
            width: 50,
          ),
          RectShimmer(
            height: 24,
            width: 50,
          ),
        ],
      ),
    );
  }

  _shimmerMovements() {
    List<Widget> list = List.empty(growable: true);
    for (int i = 0; i < 10; i++) {
      list.add(_shimmerRow());
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        RectShimmer(
          height: 54,
          bottom: 20,
        ),
        ..._shimmerMovements(),
      ],
    );
  }
}
