import 'package:flutter/material.dart';
import 'package:ummobile/statics/settings/app_icons_icons.dart';

class FormSubmit extends StatefulWidget {
  final bool isReady;
  final Function() onClick;

  FormSubmit({
    Key? key,
    required this.isReady,
    required this.onClick,
  }) : super(key: key);

  @override
  _FormSubmitState createState() => _FormSubmitState();
}

class _FormSubmitState extends State<FormSubmit>
    with SingleTickerProviderStateMixin {
  late final Animation<Color?> animationColor;
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    animationColor = ColorTween(begin: Colors.grey, end: Colors.green)
        .animate(_animationController)
      ..addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    this._animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          if (widget.isReady)
            _animationController.forward();
          else
            _animationController.reverse();

          return FloatingActionButton(
            child: Icon(AppIcons.file_upload),
            backgroundColor: animationColor.value,
            onPressed: widget.isReady ? widget.onClick : null,
          );
        });
  }
}
