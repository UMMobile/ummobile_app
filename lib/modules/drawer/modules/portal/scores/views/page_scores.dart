import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/modules/drawer/modules/portal/scores/controllers/scores_controller.dart';
import 'package:ummobile/statics/widgets/shimmers.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

import 'widgets/item_section_score.dart';

class ScoresPage extends GetView<ScoresController> {
  const ScoresPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Returns the global average widget section
    Widget _glAvg(String globalAvg) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(children: <Widget>[
          Text(globalAvg,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          Text('global_score'.tr.capitalizeFirst!,
              style: TextStyle(fontSize: 24))
        ]),
      );
    }

    /// Returns the widget list with the semesters cards
    List<Widget> _listSections(List<Semester> semesters, String avg) {
      List<Widget> sections = [_glAvg(avg)];
      for (int i = 0; i < semesters.length; i++) {
        if (semesters[i].subjects.isNotEmpty) {
          sections.add(ItemSectionScore(
            materias: semesters[i].subjects,
            cicloNombre: semesters[i].name,
          ));
        }
      }
      sections.add(SizedBox(height: 20.0));
      return sections;
    }

    return Scaffold(
      appBar: UmAppBar(
        title: 'scores'.tr.capitalizeFirst!,
        showActionIcons: false,
      ),
      body: controller.obx(
        (data) => RefreshIndicator(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: _listSections(data!.semesters, data.average.toString()),
          ),
          onRefresh: () async {
            controller.refreshContent();
          },
        ),
        onLoading: _ShimmerScores(),
        onError: (e) => controller.internetPage(e),
        onEmpty: RefreshIndicator(
          child: Center(child: Text('empty_subjects'.tr)),
          onRefresh: () async {
            controller.refreshContent();
          },
        ),
      ),
    );
  }
}

class _ShimmerScores extends StatelessWidget {
  const _ShimmerScores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        RectShimmer(
          height: 54,
          bottom: 10,
          top: 20,
          right: 120,
          left: 120,
        ),
        RectShimmer(
          height: 28,
          bottom: 20,
          right: 90,
          left: 90,
        ),
        RectShimmer(
          height: 300,
          radius: 15,
          top: 10,
          bottom: 10,
          right: 20,
          left: 20,
        ),
        RectShimmer(
          height: 300,
          radius: 15,
          top: 10,
          bottom: 10,
          right: 20,
          left: 20,
        ),
      ],
    );
  }
}
