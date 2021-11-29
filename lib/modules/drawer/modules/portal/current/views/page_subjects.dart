import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/modules/drawer/modules/portal/current/controllers/current_subjects_controller.dart';
import 'package:ummobile/statics/widgets/shimmers.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

import 'widgets/grid_subject.dart';

class SubjectsPage extends GetView<CurrentSubjectsController> {
  const SubjectsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*final silverPromedio = SliverAppBar(
      expandedHeight: 150.0,
      floating: false,
      pinned: true,
      snap: false,
      leading: Container(),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        centerTitle: true,
        title: Text(
          '9.0 Promedio General',
          textScaleFactor: 1.2,
          textAlign: TextAlign.center,
        ),
      ),
    );*/

    int _getCount() {
      double width = Get.size.width;

      if (width <= 600)
        return 2;
      else if (width <= 900)
        return 4;
      else
        return 6;
    }

    double _getRatio() {
      Size size = Get.size;

      final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
      final double itemWidth = size.width / 2;

      if (itemWidth > itemHeight) {
        return itemHeight / (itemWidth / 1.5);
      } else {
        return itemWidth / itemHeight;
      }
    }

    /// Returns the grid sliver with the user subjects
    Widget _sliverGridView(List<Subject> materias) {
      List<Widget> items = [];

      for (int i = 0; i < materias.length; i++) {
        items.add(GridSubject(
          title: materias[i].name,
          score: materias[i].score.toString(),
          state: materias[i].extras.type,
          teacher: materias[i].teacher.name,
          credits: materias[i].credits.toString(),
        ));
      }

      return SliverPadding(
        padding: EdgeInsets.all(10),
        sliver: SliverGrid.count(
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            crossAxisCount: _getCount(),
            childAspectRatio: _getRatio(),
            children: items),
      );
    }

    return Scaffold(
      appBar: UmAppBar(
        title: 'subjects'.tr.capitalizeFirst!,
        showActionIcons: false,
      ),
      body: controller.obx(
        (subjects) => RefreshIndicator(
          child: OrientationBuilder(
            builder: (context, snapshot) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  //silverPromedio,
                  _sliverGridView(subjects!)
                ],
              );
            },
          ),
          onRefresh: () async {
            controller.refreshContent();
          },
        ),
        onLoading: _SubjectsShimmer(count: _getCount(), ratio: _getRatio()),
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

class _SubjectsShimmer extends StatelessWidget {
  final int count;
  final ratio;

  const _SubjectsShimmer({
    Key? key,
    required this.count,
    required this.ratio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, snapshot) {
        return CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.all(10),
              sliver: SliverGrid.count(
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                crossAxisCount: count,
                childAspectRatio: ratio,
                children: [1, 2, 3]
                    .map(
                      (e) => RectShimmer(
                        height: 20,
                        radius: 10,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
