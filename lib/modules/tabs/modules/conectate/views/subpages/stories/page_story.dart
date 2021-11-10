import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/tabs/modules/conectate/controllers/stories_controller.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';
import 'package:video_player/video_player.dart';

import 'widgets/animated_bar.dart';
import 'widgets/user_info.dart';

class StoryScreen extends StatefulWidget {
  final List<Story> stories;
  final int startIndex;
  final int userId;

  StoryScreen({
    Key? key,
    required this.stories,
    this.startIndex = 0,
    required this.userId,
  }) : super(key: key);

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  StoriesController controller = Get.find<StoriesController>();
  late PageController _pageController;
  VideoPlayerController? _videoController;
  late AnimationController _animationController;
  int _currentIndex = 0;

  ImageChunkEvent? imageChunk;
  bool animStarted = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;
    _pageController = PageController();
    _animationController = AnimationController(vsync: this);

    final Story firstStory = widget.stories.first;
    _loadStory(story: firstStory, animateToPage: false);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.stop();
        _animationController.reset();
        setState(() {
          if (_currentIndex + 1 < widget.stories.length) {
            _currentIndex++;
            _loadStory(story: widget.stories[_currentIndex]);
          } else {
            if (widget.userId + 1 < controller.groups.length) {
              List<Group> users = controller.groups;
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      transitionDuration: Duration(seconds: 0),
                      pageBuilder: (context, animation1, animation2) =>
                          StoryScreen(
                            stories: users[widget.userId + 1].stories,
                            startIndex: 0,
                            userId: widget.userId + 1,
                          )));
            } else {
              Get.back();
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Story story = widget.stories[_currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (details) => _onTapUp(details, story),
        onLongPressStart: (details) => _onLongPressStart(details, story),
        onLongPressEnd: (details) => _onLongPressEnd(details, story),
        onPanUpdate: (details) => _onDrag(details),
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.stories.length,
              itemBuilder: (context, i) {
                switch (story.type) {
                  case MediaType.Image:
                    return Image.network(
                      story.content,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          if (imageChunk != null && !animStarted) {
                            _animationController.forward();
                            animStarted = true;
                          }
                          imageChunk = ImageChunkEvent(
                              cumulativeBytesLoaded: 0, expectedTotalBytes: 0);
                          return child;
                        }

                        imageChunk = loadingProgress;

                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    );

                  case MediaType.Text:
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: <Color>[
                        Colors.pink,
                        Colors.deepPurple,
                      ])),
                      child: Center(
                        child: Text(
                          story.content,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 32, color: Colors.white),
                        ),
                      ),
                    );

                  case MediaType.Video:
                    if (_videoController != null &&
                        _videoController!.value.isInitialized) {
                      return FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _videoController!.value.size.width,
                            height: _videoController!.value.size.height,
                            child: VideoPlayer(_videoController!),
                          ));
                    }
                    break;
                  case MediaType.Unknown:
                    return const SizedBox.shrink();
                }
                return const SizedBox.shrink();
              },
            ),
            Positioned(
                top: 40,
                left: 10,
                right: 10,
                child: Column(
                  children: [
                    Row(
                      children: widget.stories
                          .asMap()
                          .map((key, value) => MapEntry(
                              key,
                              AnimatedBar(
                                animationController: _animationController,
                                position: key,
                                currentIndex: _currentIndex,
                              )))
                          .values
                          .toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 1.5,
                        vertical: 10.0,
                      ),
                      child: UserInfo(user: controller.groups[widget.userId]),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void _onTapUp(TapUpDetails details, Story story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex--;
          _loadStory(story: widget.stories[_currentIndex]);
        } else if (widget.userId - 1 >= 0) {
          List<Group> users = controller.groups;
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(seconds: 0),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      StoryScreen(
                        stories: users[widget.userId - 1].stories,
                        startIndex: 0,
                        userId: widget.userId - 1,
                      )));
        } else {
          Navigator.of(context).pop();
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentIndex + 1 < widget.stories.length) {
          _currentIndex++;
          _loadStory(story: widget.stories[_currentIndex]);
        } else {
          // Out of bounds - loop story
          if (widget.userId + 1 < controller.groups.length) {
            List<Group> users = controller.groups;
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    transitionDuration: Duration(seconds: 0),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        StoryScreen(
                          stories: users[widget.userId + 1].stories,
                          userId: widget.userId + 1,
                        )));
          } else {
            Navigator.of(context).pop();
          }
        }
      });
    }
  }

  void _onLongPressStart(LongPressStartDetails details, Story story) {
    _animationController.stop();
    if (story.type == MediaType.Video) {
      _videoController!.pause();
    }
  }

  void _onLongPressEnd(LongPressEndDetails details, Story story) {
    _animationController.forward();
    if (story.type == MediaType.Video) {
      _videoController!.play();
    }
  }

  void _onDrag(DragUpdateDetails details) {
    // Swiping in left direction.
    if (details.delta.dx > 0) {
      if (widget.userId - 1 >= 0) {
        List<Group> users = controller.groups;
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(seconds: 0),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    StoryScreen(
                      stories: users[widget.userId - 1].stories,
                      startIndex: 0,
                      userId: widget.userId - 1,
                    )));
      }
    }

    // Swiping in right direction.
    if (details.delta.dx < 0) {
      if (widget.userId + 1 < controller.groups.length) {
        List<Group> users = controller.groups;
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(seconds: 0),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    StoryScreen(
                      stories: users[widget.userId + 1].stories,
                      startIndex: 0,
                      userId: widget.userId + 1,
                    )));
      }
    }

    // Swiping in down direction
    if (details.delta.dy > 45) {
      Get.back();
    }
  }

  void _loadStory({required Story story, bool animateToPage = true}) {
    _animationController.stop();
    _animationController.reset();
    animStarted = false;

    switch (story.type) {
      case MediaType.Image:
      case MediaType.Text:
        _animationController.duration = Duration(seconds: story.duration);
        if (story.type == MediaType.Text) _animationController.forward();
        break;
      case MediaType.Video:
        _videoController = null;
        _videoController?.dispose();
        _videoController = VideoPlayerController.network(story.content)
          ..initialize().then((value) {
            setState(() {});
            if (_videoController!.value.isInitialized) {
              _animationController.duration = _videoController!.value.duration;
              _videoController!.play();
              _animationController.forward();
            }
          });
        break;
      case MediaType.Unknown:
        break;
    }

    if (animateToPage) {
      _pageController.animateToPage(_currentIndex,
          duration: const Duration(milliseconds: 1), curve: Curves.easeInOut);
    }
  }
}
