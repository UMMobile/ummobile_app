import 'package:flutter/material.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class ItemSectionScore extends StatelessWidget {
  final List<Subject> materias;
  final String cicloNombre;

  ItemSectionScore(
      {Key? key, required this.materias, required this.cicloNombre})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Lista de las materias presentes en el semestre con su estilo
    List<Widget> notas() {
      List<Widget> texts = <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                cicloNombre,
                style: TextStyle(fontSize: 18),
              )),
              Text(
                "",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        )
      ];
      for (int i = 0; i < materias.length; i++) {
        Widget nota = Column(children: <Widget>[
          Row(
            children: [
              Expanded(
                  child: Text(
                materias[i].name,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              Container(
                margin: EdgeInsets.only(left: 30.0),
                child: Text(
                  materias[i].score.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Divider()
        ]);
        texts.add(nota);
      }
      return texts;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(children: notas())),
    );
  }
}
