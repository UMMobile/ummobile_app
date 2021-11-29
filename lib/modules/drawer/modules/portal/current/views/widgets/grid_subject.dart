import 'package:flutter/material.dart';
import 'package:ummobile/statics/widgets/adaptable_text.dart';

class GridSubject extends StatelessWidget {
  /// The subject name
  final String title;

  /// The subject teacher in charge
  final String teacher;

  /// The credits value
  final String credits;

  /// The current state
  final String state;

  /// The current achieved score
  final String score;

  const GridSubject(
      {Key? key,
      required this.title,
      required this.teacher,
      required this.credits,
      required this.score,
      required this.state})
      : super(key: key);

//metodo para definir el color de la calificacion de la materia
  Color _textColor(String value) {
    if (double.parse(value) >= 70) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 3,
            blurRadius: 2,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Container(
        margin:
            EdgeInsets.only(top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
        child: Column(
          children: <Widget>[
            // *Principal information
            Expanded(
                child: Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            score,
                            style: TextStyle(
                                fontSize: 18, color: _textColor(score)),
                          ),
                        ),
                        Expanded(
                          child: AdaptableText(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ))),

            // *Secondary Informatio
            Row(
              children: <Widget>[
                Text(credits,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Container(
                  margin: EdgeInsets.only(right: 5.0),
                  child: Text(state,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                    child: Text(
                  teacher,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 14),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
