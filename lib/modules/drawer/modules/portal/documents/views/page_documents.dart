import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/modules/drawer/modules/portal/documents/controllers/documents_controller.dart';
import 'package:ummobile/statics/widgets/shimmers.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

import 'widgets/button_archive.dart';

class DocumentsPage extends GetView<DocumentsController> {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _archivos(List<Document> archives) {
      List<Widget> list = [
        Container(
          margin: EdgeInsets.all(20),
          child: Text(
            'archives_web_consult'.tr,
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ];
      for (int i = 0; i < archives.length; i++) {
        list.add(ButtonArchive(archiveName: archives[i].name));
      }
      list.add(SizedBox(
        height: 20.0,
      ));
      return list;
    }

    return Scaffold(
      appBar: UmAppBar(
        title: 'archives'.tr.capitalizeFirst!,
        showActionIcons: false,
      ),
      body: controller.obx(
        (documents) => RefreshIndicator(
          onRefresh: () async {
            controller.refreshContent();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: _archivos(documents!),
          ),
        ),
        onLoading: _ShimmerArchives(),
        onError: (e) => controller.internetPage(e),
      ),
    );
  }
}

class _ShimmerArchives extends StatelessWidget {
  const _ShimmerArchives({Key? key}) : super(key: key);

  List<Widget> _shimmerButtons() {
    final rand = Random();
    List<Widget> list = List.empty(growable: true);
    for (int i = 0; i < 7; i++) {
      list.add(
        RectShimmer(
          height: (50 + rand.nextInt(90 - 50)).toDouble(),
          radius: 16,
          top: 5,
          bottom: 5,
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        RectShimmer(
          height: 14,
          top: 20,
          bottom: 20,
        ),
        ..._shimmerButtons(),
      ],
    );
  }
}
