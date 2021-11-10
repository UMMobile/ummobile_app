import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/modules/login/models/login_session.dart';

import 'add_login.dart';
import 'login_card.dart';

/// * Page in charge of loading all the stored users inside the Json file and
/// * display them in a grid view
class QuickLogins extends StatelessWidget {
  const QuickLogins({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _userList({
      required List<LoginSession> list,
      required LoginController controller,
    }) {
      List<Widget> widgetList = List<Widget>.empty(growable: true);
      int count = 0;
      list.forEach((element) {
        widgetList.add(LoginCard(
          userIndex: count,
          credential: element.credential,
          auth: element.authCredentials,
          user: element.name,
          image: element.image,
        ));
        count++;
      });

      if (controller.isNotFull()) {
        widgetList.add(AddLogin());
      }

      return widgetList;
    }

    return GetX<LoginController>(builder: (_) {
      List<Widget> logins = _userList(list: _.users, controller: _);
      int count = logins.length >= 2 ? 2 : 1;
      bool isTwoRows = logins.length >= 3;
      bool isTwoCols = logins.length >= 2;
      return Container(
        child: Column(
          children: [
            Container(
              height: 146.0 * (isTwoRows ? 2 : 1),
              width: 140 * (isTwoCols ? 2 : 1),
              child: GridView.count(
                clipBehavior: Clip.none,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                crossAxisCount: count,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: logins,
              ),
            ),
            if (!_.isNotFull())
              TextButton(
                child: Text(
                  'goto_login_fields'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () =>
                    Get.find<LoginController>().showQuickLogins(false),
              ),
          ],
        ),
      );
    });
  }
}
