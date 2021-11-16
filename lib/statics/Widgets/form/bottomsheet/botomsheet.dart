import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bottomsheet_controller.dart';

class BottomSheetButton extends StatefulWidget {
  /// The bottomsheet hint text
  final String? hint;

  /// The string list of the bottomsheet options
  final List<String> children;

  /// The action called when an option [id] is selected
  final Function(int id) onSelect;

  /// The options leading icon in the bottomsheet
  final IconData? icon;

  /// The controller in charge of this button
  final BottomSheetController controller;

  BottomSheetButton({
    Key? key,
    required this.children,
    required this.onSelect,
    required this.controller,
    this.hint,
    this.icon,
  }) : super(key: key);

  @override
  _BottomSheetButtonState createState() => _BottomSheetButtonState();
}

class _BottomSheetButtonState extends State<BottomSheetButton> {
  List<ListTile> _listTiles() {
    List<ListTile> tiles = List.empty(growable: true);

    for (int i = 0; i < widget.children.length; i++) {
      tiles.add(
        ListTile(
          leading: (widget.icon != null) ? Icon(widget.icon) : null,
          title: Text(widget.children[i]),
          onTap: () {
            setState(() {
              widget.controller.id = i;
              widget.controller.text = widget.children[i];
            });
            widget.onSelect(i);
            Get.back();
          },
        ),
      );
    }

    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  minimumSize: Size(double.infinity, 40.0),
                  onSurface: Color.fromRGBO(110, 86, 198, 0.5),
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  )),
              child: Row(
                children: <Widget>[
                  Text(
                    (widget.controller.id != null)
                        ? widget.children[widget.controller.id!]
                        : (widget.hint != null)
                            ? widget.hint!
                            : "",
                    style: (widget.controller.id != null)
                        ? null
                        : TextStyle(color: Theme.of(context).hintColor),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(Icons.keyboard_arrow_down,
                      color: Theme.of(context).colorScheme.secondary)
                ],
              ),
              onPressed: () {
                Get.bottomSheet(
                    ListView(
                      shrinkWrap: true,
                      children: _listTiles(),
                    ),
                    backgroundColor: Get.theme.scaffoldBackgroundColor,
                    isDismissible: true,
                    enableDrag: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ));
              },
            ),
          ],
        ));
  }
}
