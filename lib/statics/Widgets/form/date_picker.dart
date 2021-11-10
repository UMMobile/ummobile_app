import 'package:flutter/material.dart';

class UMDatePicker extends StatelessWidget {
  /// The marker to know if is enable or not.
  final bool enable;

  /// The gap between the icon and text. By default 8.0.
  final double gap;

  /// The marker to know if should be displayed inline or in block. By default true.
  final bool displayText;

  /// The marker to know if the selected date should be displayed. By default true.
  final bool displaySelected;

  /// The marker to know if should be displayed inline or in block. By default false.
  final bool inline;

  /// The icon for the picker. By default Icons.calendar_today.
  final IconData? icon;

  /// The text for the picker. By default "Selecciona la fecha".
  final String? label;

  /// The date time selected to be dysplayed. By default null and "-" is displayed.
  final String? selected;

  /// The color for the text and icon. By default the accent color of the theme.
  final Color? color;

  /// The initial selected date on the calendar.
  final DateTime? initialDate;

  /// The first able date to select.
  final DateTime? firstDate;

  /// The last able date to select.
  final DateTime? lastDate;

  /// The function to be executed on select receiving the DateTime selected.
  final void Function(DateTime?)? onSelect;

  /// The limit days since the start date.
  final int? limitDays;

  UMDatePicker({
    this.enable: true,
    this.gap: 8.0,
    this.displayText: true,
    this.displaySelected: true,
    this.inline: false,
    this.icon,
    this.label,
    this.selected,
    this.color,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onSelect,
    this.limitDays,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> content = [
      Padding(
        padding: EdgeInsets.only(bottom: this.gap),
        child: Icon(
          icon ?? Icons.calendar_today,
          color: enable
              ? color ?? Theme.of(context).colorScheme.secondary
              : Colors.grey,
          size: 32,
        ),
      ),
      if (this.displayText)
        Text(
          this.label ?? 'Selecciona la fecha',
          style: TextStyle(
              color: enable
                  ? color ?? Theme.of(context).colorScheme.secondary
                  : Colors.grey),
        ),
      Divider(
        height: 2,
        color: Colors.transparent,
      ),
      if (this.displaySelected)
        Text(
          this.selected ?? '-',
          style: TextStyle(
              color: this.selected != null
                  ? Theme.of(context).primaryColor
                  : Colors.grey),
        ),
    ];

    DateTime _initialDate = this.initialDate ?? DateTime.now();
    DateTime _firstDate = this.firstDate ?? _initialDate;
    DateTime _lastDate =
        this.lastDate ?? DateTime(DateTime.now().year + 1, 12, 31);
    if (limitDays != null) {
      _lastDate = _firstDate.add(Duration(days: limitDays!));
    }

    return TextButton(
      onPressed: () {
        if (enable) {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          showDatePicker(
            context: context,
            initialDate: _initialDate,
            firstDate: _firstDate,
            lastDate: _lastDate,
          ).then((date) {
            if (onSelect != null) {
              onSelect!(date);
            }
          });
        }
      },
      child: this.inline ? Row(children: content) : Column(children: content),
    );
  }
}
