import 'package:flutter/material.dart';

class RowUserInfo extends StatelessWidget {
  final String? title;
  final String? data;
  final TextAlign titleAlign;
  final TextAlign valueAlign;

  RowUserInfo({
    Key? key,
    this.title,
    this.data,
    this.titleAlign: TextAlign.start,
    this.valueAlign: TextAlign.end,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            /// * Row section
            if (this.title != null)
              Expanded(
                flex: 1,
                child: Text(
                  this.title!,
                  textAlign: this.titleAlign,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

            /// * User value
            if (this.data != null)
              Expanded(
                flex: 2,
                child: Container(
                  child: Text(
                    data ?? "",
                    textAlign: this.valueAlign,
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                ),
              ),
          ],
        ),
        Divider()
      ]),
    );
  }
}
