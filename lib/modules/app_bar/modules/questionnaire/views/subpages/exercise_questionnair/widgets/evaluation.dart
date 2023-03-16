import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ummobile/statics/Widgets/form/bottomsheet/botomsheet.dart';

class QuestionsElements extends StatefulWidget {
  const QuestionsElements({Key? key}) : super(key: key);

  @override
  State<QuestionsElements> createState() => _QuestionsElementsState();
}

class _QuestionsElementsState extends State<QuestionsElements> {
  List<String> items = ["00 Rectoria", "01 VRF", "02 VRA", "03 VRE"];
  String? selectedItem = "00 Rectoria";

  @override
  Widget build(BuildContext context) {
    return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          SizedBox(height: 25),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
                'select'.trParams({
                  'element': 'department'.tr,
                }).tr,
                style: TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
          )
        ]);
  }
}
