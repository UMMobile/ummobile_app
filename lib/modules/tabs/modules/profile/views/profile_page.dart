import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/modules/tabs/controllers/navigation_controller.dart';
import 'package:ummobile/modules/tabs/modules/profile/controllers/profile_controller.dart';
import 'package:ummobile/modules/tabs/modules/profile/models/user_credentials.dart';
import 'package:ummobile/statics/widgets/shimmers.dart';

import 'widgets/widgets_export.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.find<ProfileController>();

  @override
  bool get wantKeepAlive => true;

  /// * Method to display the name of the user
  Widget _username(String username) {
    return Text(
      username,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
    );
  }

  /// * Method to display the credential of the user
  Widget _userId(String id) {
    return Text(
      id,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: UmAppBar(
        title: 'profile'.tr.capitalizeFirst!,
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Get.find<NavigationController>()
                  .drawerKey
                  .currentState!
                  .openDrawer();
            }),
      ),
      body: controller.obx(
        (user) => RefreshIndicator(
          onRefresh: () async {
            controller.refreshContent();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Container(
                margin: EdgeInsets.only(top: 25),
                child: UserImage(
                  profileImage: user!.image,
                ),
              ),
              _username(user.name + ' ' + user.surnames),
              _userId('(' + userId + ')'),
              UserInfo(user: user),
            ],
          ),
        ),
        onLoading: _UserShimmerPage(),
        onError: (e) => controller.internetPage(e),
      ),
    );
  }
}

class _UserShimmerPage extends StatelessWidget {
  const _UserShimmerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _dataShimmer() {
      List<Widget> children = List.empty(growable: true);

      for (int i = 0; i < 5; i++) {
        var _random = new Random();
        children.add(
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RectShimmer(
                  height: 14,
                  width: (80 + _random.nextInt(100 - 80)).toDouble(),
                ),
                RectShimmer(
                  height: 14,
                  width: (80 + _random.nextInt(100 - 80)).toDouble(),
                )
              ],
            ),
          ),
        );
      }
      return children;
    }

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      physics: NeverScrollableScrollPhysics(),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundShimmer(top: 25, bottom: 20, size: 170),
          ],
        ),
        RectShimmer(bottom: 10, height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: RectShimmer(bottom: 10, height: 16),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundShimmer(size: 12, right: 10),
              RoundShimmer(size: 12, right: 10),
              RoundShimmer(size: 12, right: 10),
            ],
          ),
        ),
        ..._dataShimmer(),
      ],
    );
  }
}
