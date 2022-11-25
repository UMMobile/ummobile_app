import 'package:flutter/material.dart';

// Crea un Widget Form
class QuestionsPage extends StatefulWidget {
  @override
  QuestionsPageState createState() {
    return QuestionsPageState();
  }
}

// Crea una clase State correspondiente. Esta clase contendrá los datos relacionados con
// el formulario.
class QuestionsPageState extends State<QuestionsPage> {
  // Crea una clave global que identificará de manera única el widget Form
  // y nos permita validar el formulario
  //
  // Nota: Esto es un GlobalKey<FormState>, no un GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Crea un widget Form usando el _formKey que creamos anteriormente
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
