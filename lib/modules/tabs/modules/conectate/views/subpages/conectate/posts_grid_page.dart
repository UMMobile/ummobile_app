import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/modules/tabs/modules/conectate/controllers/posts_controller.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

import 'widgets/item_grid_post.dart';

/// * Page to see more posts from the provided list as for the widget in home

class PostsGridPage extends GetView<PostsController> {
  PostsGridPage({Key? key, required this.list, required this.subPageTitle})
      : super(key: key);

  final RxList<Post> list;
  final String subPageTitle;

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

    if (itemWidth > itemHeight)
      return itemHeight / (itemWidth / 1.5);
    else
      return itemWidth / itemHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UmAppBar(
        title: subPageTitle,
      ),
      body: controller.obx(
        (state) => RefreshIndicator(
          onRefresh: () async {
            await controller.refreshPosts();
          },
          child: OrientationBuilder(builder: (context, snapshot) {
            return GridView.count(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              crossAxisCount: _getCount(),
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
              childAspectRatio: _getRatio(),
              children: list
                  .map(
                    (post) => ItemGridPost(
                      cardTitle: post.title,
                      imagePath: post.image,
                      url: post.url,
                    ),
                  )
                  .toList(),
            );
          }),
        ),
        onError: (e) {
          return Center(child: controller.internetPage(e));
        },
        onLoading:
            // ignore: todo
            Center(child: CircularProgressIndicator()), //TODO: shimmer effect
      ),
    );
  }
}
