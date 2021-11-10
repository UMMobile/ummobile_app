import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/tabs/controllers/navigation_controller.dart';
import 'package:ummobile/modules/tabs/modules/conectate/controllers/posts_controller.dart';
import 'package:ummobile/modules/tabs/modules/conectate/views/subpages/conectate/posts_grid_page.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

import 'item_list_post.dart';

/// * List that renders the posts given
class ListPosts extends StatelessWidget {
  final String title;
  final RxList<Post> postsObservable;
  final int postsToShow;
  final String subPageTitle;
  final String emptyText;

  ListPosts({
    Key? key,
    required this.title,
    required this.postsObservable,
    required this.postsToShow,
    required this.subPageTitle,
    this.emptyText = "Actualemente no hay registros disponibles",
  }) : super(key: key);

  final _postsController = Get.find<PostsController>();

  @override
  Widget build(BuildContext context) {
    /// * Upper text row of the widget
    final sliderHeader = Obx(() {
      /// * button for list expanded page if posts are not empty
      final seeMore = postsObservable.isNotEmpty
          ? TextButton(
              style: TextButton.styleFrom(primary: Get.theme.hintColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                        margin: EdgeInsets.only(right: 2),
                        child: Text(
                          'see_more'.tr,
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 16, color: Get.theme.hintColor),
                ],
              ),
              onPressed: () => postsObservable.isNotEmpty
                  ? Get.find<NavigationController>().goToSubTabView(
                      PostsGridPage(
                        list: postsObservable,
                        subPageTitle: subPageTitle,
                      ),
                      context)
                  : null)
          : Container();

      return Container(
          margin: EdgeInsets.only(bottom: 10.0, left: 20.0, right: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Text(title,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Expanded(flex: 2, child: seeMore),
            ],
          ));
    });

    /// * Posts list
    final sliderContent = _postsController.obx(
        (state) {
          List<Widget> eventList = [
            SizedBox(width: 20.0),
          ];

          if (postsObservable.isEmpty)
            return Container(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text(emptyText),
            );

          if (postsToShow < postsObservable.length) {
            for (int i = 0; i < postsToShow; i++) {
              eventList.add(ItemListPost(
                  cardTitle: postsObservable[i].title,
                  imagePath: postsObservable[i].image,
                  url: postsObservable[i].url));
            }
          } else {
            for (int i = 0; i < postsObservable.length; i++) {
              eventList.add(ItemListPost(
                  cardTitle: postsObservable[i].title,
                  imagePath: postsObservable[i].image,
                  url: postsObservable[i].url));
            }
          }
          return Container(
              height: 170,
              child: ListView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: eventList));
        },
        onLoading: _ShimmerListPosts(),
        onError: (message) {
          String text;
          switch (message) {
            case "userError":
              text = 'list_user_disconnection_content'.tr;
              break;
            case "serverError":
              text = 'list_server_disconnection_content'.tr;
              break;
            default:
              text = message!;
          }

          return Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          );
        });

    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: <Widget>[sliderHeader, sliderContent],
        ));
  }
}

class _ShimmerListPosts extends StatelessWidget {
  const _ShimmerListPosts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        padding: EdgeInsets.only(left: 20),
        itemBuilder: (_, i) => Container(
          margin: EdgeInsets.only(right: 20),
          child: FadeShimmer(
            height: 170,
            width: 170,
            radius: 20,
            fadeTheme: Get.isDarkMode ? FadeTheme.dark : FadeTheme.light,
          ),
        ),
      ),
    );
  }
}
