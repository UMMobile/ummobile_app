import 'package:flutter/material.dart';
import 'package:ummobile/modules/app_bar/modules/rules/models/rules.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:get/get.dart';

import 'page_rule.dart';

class SchoolRules extends StatelessWidget {
  final List<Rule> rules;

  SchoolRules({Key? key, this.rules: const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UmAppBar(
        title: 'school_rules'.tr,
        showActionIcons: false,
      ),
      body: ListView.separated(
        itemCount: this.rules.length,
        itemBuilder: (BuildContext context, int i) => ListTile(
          title: Text(this.rules[i].name),
          trailing: Icon(Icons.arrow_forward_ios_outlined),
          onTap: () => Get.to(() => RulePage(rule: this.rules[i])),
        ),
        separatorBuilder: (context, index) => Divider(height: 0),
      ),
    );
  }
}
