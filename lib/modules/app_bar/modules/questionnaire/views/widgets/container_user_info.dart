import 'package:flutter/material.dart';

class ContainerUserInfo extends StatelessWidget {
  final String title;
  final String data;

  const ContainerUserInfo({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20.0),
        child: Column(
          children: <Widget>[
            Text(title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(height: 7),
            Container(
                width: double.infinity,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 0.7),
                        bottom: BorderSide(width: 0.7))),
                child: Text(
                  data,
                  textAlign: TextAlign.center,
                )),
          ],
        ));
  }
}
