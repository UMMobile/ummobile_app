import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/tabs/modules/conectate/controllers/stories_controller.dart';
import 'package:ummobile/modules/tabs/modules/conectate/views/subpages/stories/page_story.dart';
import 'package:ummobile/statics/widgets/shimmers.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class ListStories extends GetView<StoriesController> {
  const ListStories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 142,
      child: controller.obx(
        (groups) => ListView(
          padding: EdgeInsets.only(left: 10),
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          children: usersRow(groups!, controller),
        ),
        onEmpty: Center(
          child: Text('empty_posts'.trParams({
            'element': 'stories'.tr,
          })),
        ),
        onLoading: _ListStoriesShimmer(),
        onError: (message) => Center(
          child: Text(
            message!,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  List<Widget> usersRow(List<Group> users, StoriesController _) {
    List<Widget> userIcons = List.empty(growable: true);

    for (int i = 0; i < users.length; i++) {
      userIcons.add(
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            children: [
              Material(
                elevation: 0,
                clipBehavior: Clip.hardEdge,
                type: MaterialType.circle,
                color: Colors.transparent,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(0, 208, 216, 1),
                            Color.fromRGBO(110, 86, 198, 1)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Hero(
                      tag: users[i].name,
                      child: ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/img/default-img.jpg',
                          image: users[i].image,
                          fit: BoxFit.cover,
                          height: 95,
                          width: 95,
                          imageErrorBuilder: (context, object, stacktrace) =>
                              Image.asset(
                            "assets/img/default-img.jpg",
                            fit: BoxFit.cover,
                            height: 95,
                            width: 95,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor:
                              Get.theme.colorScheme.secondary.withOpacity(0.5),
                          onTap: () => Get.to(
                            () => StoryScreen(
                              stories: users[i].stories,
                              userId: i,
                            ),
                            transition: Transition.zoom,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 100,
                margin: EdgeInsets.only(top: 3),
                child: Text(
                  users[i].name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return userIcons;
  }
}

class _ListStoriesShimmer extends StatelessWidget {
  const _ListStoriesShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 10.0),
      scrollDirection: Axis.horizontal,
      children: [
        Column(
          children: [
            RoundShimmer(size: 110),
          ],
        ),
        SizedBox(width: 10),
        Column(
          children: [
            RoundShimmer(size: 110),
          ],
        ),
        SizedBox(width: 10),
        Column(
          children: [
            RoundShimmer(size: 110),
          ],
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
