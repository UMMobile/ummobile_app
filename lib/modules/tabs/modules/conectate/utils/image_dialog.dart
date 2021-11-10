import 'package:flutter/material.dart';

/// * Displays the post image in an interactive dialog
class ImageDialog extends StatefulWidget {
  final String imagePath;
  const ImageDialog({Key? key, required this.imagePath}) : super(key: key);
  @override
  _ImageDialogState createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  TransformationController transController = TransformationController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.ease);

    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Center(
        child: InteractiveViewer(
            clipBehavior: Clip.none,
            child: (widget.imagePath.isNotEmpty)
                ? Image.network(widget.imagePath, fit: BoxFit.cover)
                : Image.asset(
                    'assets/img/default-img.jpg',
                    fit: BoxFit.cover,
                  ),
            transformationController: transController,
            boundaryMargin: EdgeInsets.all(5.0),
            onInteractionEnd: (ScaleEndDetails endDetails) {
              transController.value = Matrix4.identity();
            }),
      ),
    );
  }
}
