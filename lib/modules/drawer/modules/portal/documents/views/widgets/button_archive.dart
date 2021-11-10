import 'package:flutter/material.dart';
import 'package:ummobile/statics/settings/colors.dart';

class ButtonArchive extends StatelessWidget {
  final String? archiveName;

  ButtonArchive({Key? key, this.archiveName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: TextButton(
          style: TextButton.styleFrom(
              minimumSize: Size(double.infinity, 40.0),
              padding: EdgeInsets.all(10.0),
              primary: AppColorThemes.textColor,
              backgroundColor: Theme.of(context).cardColor,
              onSurface: Color.fromRGBO(110, 110, 110, 0.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.green, width: 2))),
          child: Row(children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.fiber_manual_record,
                color: Colors.green,
              ),
            ),
            Expanded(
              child: Text(
                archiveName!,
                style: TextStyle(fontSize: 16),
              ),
            )
          ]),
          onPressed: () {
            print('no image available');
          },
        ));
  }
}
