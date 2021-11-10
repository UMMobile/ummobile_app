import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum YesOrNoOptions { yes, no }

class UMYesOrNo extends StatefulWidget {
  /// The marker to know if the widget is enable.
  final bool enable;

  /// The marker to know if it should be extended.
  final bool extend;

  /// The initial value.
  final bool? initialValue;

  /// The label for the widget
  final String? label;

  /// The marker to know if the widget should be refresh when is off the screen.
  final bool keepAlive;

  /// The function to be executed on change.
  final void Function(YesOrNoOptions?)? onChanged;

  UMYesOrNo({
    this.enable: true,
    this.extend: false,
    this.keepAlive: true,
    this.initialValue,
    this.label,
    this.onChanged,
  });

  @override
  _UMYesOrNoState createState() => _UMYesOrNoState();
}

class _UMYesOrNoState extends State<UMYesOrNo>
    with AutomaticKeepAliveClientMixin {
  late YesOrNoOptions? group;

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  void initState() {
    this.group = widget.initialValue != null
        ? widget.initialValue!
            ? YesOrNoOptions.yes
            : YesOrNoOptions.no
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Column(
        crossAxisAlignment: widget.extend
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Text(
              widget.label!,
              style: TextStyle(
                color: widget.enable
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey,
                fontWeight: widget.enable ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: widget.extend
                ? MainAxisAlignment.spaceAround
                : MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Radio(
                    activeColor: widget.enable
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.grey,
                    value: YesOrNoOptions.yes,
                    groupValue: this.group,
                    onChanged: (YesOrNoOptions? option) {
                      if (widget.enable) {
                        if (widget.onChanged != null) {
                          widget.onChanged!(option);
                        }
                        setState(() => this.group = YesOrNoOptions.yes);
                      }
                    },
                  ),
                  Text(
                    'yes'.tr,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                    activeColor: widget.enable
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.grey,
                    value: YesOrNoOptions.no,
                    groupValue: this.group,
                    onChanged: (YesOrNoOptions? option) {
                      if (widget.enable) {
                        if (widget.onChanged != null) {
                          widget.onChanged!(option);
                        }
                        setState(() => this.group = YesOrNoOptions.no);
                      }
                    },
                  ),
                  Text(
                    'No',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
