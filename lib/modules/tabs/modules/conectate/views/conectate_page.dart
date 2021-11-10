import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/modules/tabs/controllers/navigation_controller.dart';
import 'package:ummobile/modules/tabs/modules/conectate/controllers/posts_controller.dart';

import 'widgets/list_post.dart';
import 'widgets/list_stories.dart';

class ConectatePage extends StatefulWidget {
  @override
  _ConectatePageState createState() => _ConectatePageState();
}

class _ConectatePageState extends State<ConectatePage>
    with AutomaticKeepAliveClientMixin {
  final PostsController _postsController = Get.find<PostsController>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: UmAppBar(
        child: SvgPicture.asset(
          'assets/img/short_logo.svg',
          height: 30,
        ),
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Get.find<NavigationController>()
                  .drawerKey
                  .currentState!
                  .openDrawer();
            }),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1000));
          _postsController.refreshPosts();
        },
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          addAutomaticKeepAlives: true,
          children: <Widget>[
            ListStories(),
            ListPosts(
              title: 'news_list_header'.tr,
              subPageTitle: 'news'.tr.capitalizeFirst!,
              postsObservable: _postsController.newsObservable,
              postsToShow: 5,
              emptyText: 'empty_posts'.trParams({
                'element': 'news'.tr,
              }),
            ),
            ListPosts(
              title: 'blog_list_header'.tr,
              subPageTitle: 'Blog',
              postsObservable: _postsController.blogObservable,
              postsToShow: 5,
              emptyText: 'empty_posts'.trParams({
                'element': 'publications'.tr,
              }),
            ),
            ListPosts(
              title: 'events_list_header'.tr,
              subPageTitle: 'events'.tr.capitalizeFirst!,
              postsObservable: _postsController.eventsObservable,
              postsToShow: 5,
              emptyText: 'empty_posts'.trParams({
                'element': 'events'.tr,
              }),
            ),
          ],
        ),
      ),
    );
  }
}
