import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/controllers/questionnaire_controller.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/statics/widgets/shimmers.dart';

import 'subpages/answered_page.dart';
import 'subpages/unanswered_page.dart';

class HealthQuestionnaire extends GetView<QuestionnaireController> {
  HealthQuestionnaire({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UmAppBar(
        title: 'questionnaire'.tr.capitalizeFirst!,
        showActionIcons: false,
      ),
      body: controller.obx(
        (state) => RefreshIndicator(
          onRefresh: () async => controller.refreshContent(),
          child: Obx(() => controller.isAnswered.value
              ? QuestionnaireAnsweredPage(
                  currentAnswer: controller.currentAnswer,
                )
              : QuestionnaireUnAnsweredPage()),
        ),
        onLoading: _ShimmerHealthQuestionnaire(),
        onError: (e) => controller.internetPage(e),
      ),
    );
  }
}

class _ShimmerHealthQuestionnaire extends StatelessWidget {
  const _ShimmerHealthQuestionnaire({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      children: [
        RectShimmer(
          height: 14,
          bottom: 5,
          left: 60,
          right: 60,
        ),
        RectShimmer(
          height: 14,
          bottom: 20,
          left: 90,
          right: 90,
        ),
        RectShimmer(
          height: 14,
          bottom: 10,
          left: 100,
          right: 100,
        ),
        RectShimmer(
          height: 36,
          bottom: 20,
        ),
        RectShimmer(
          height: 18,
          bottom: 5,
          right: 200,
        ),
        RectShimmer(
          height: 18,
          bottom: 5,
          right: 30,
        ),
        RectShimmer(
          height: 18,
          bottom: 20,
          right: 120,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RectShimmer(height: 14, width: 100),
            RectShimmer(height: 14, width: 100),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RectShimmer(height: 36, width: 150),
            RectShimmer(height: 36, width: 150),
          ],
        ),
        SizedBox(height: 20),
        RectShimmer(
          height: 14,
          bottom: 10,
          left: 100,
          right: 100,
        ),
        RectShimmer(
          height: 36,
          bottom: 20,
        ),
        RectShimmer(
          height: 14,
          bottom: 10,
          left: 100,
          right: 100,
        ),
        RectShimmer(
          height: 36,
          bottom: 20,
        ),
        RectShimmer(height: 14, bottom: 5),
        RectShimmer(height: 14, bottom: 20, right: 90),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Row(
                children: [
                  RoundShimmer(size: 24, right: 20),
                  RectShimmer(height: 14, width: 50),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  RoundShimmer(size: 24, right: 20),
                  RectShimmer(height: 14, width: 50),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        RectShimmer(height: 14, bottom: 5),
        RectShimmer(height: 14, bottom: 20, right: 90),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Row(
                children: [
                  RoundShimmer(size: 24, right: 20),
                  RectShimmer(height: 14, width: 50),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  RoundShimmer(size: 24, right: 20),
                  RectShimmer(height: 14, width: 50),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
