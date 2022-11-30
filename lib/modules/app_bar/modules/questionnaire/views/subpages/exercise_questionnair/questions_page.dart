import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ummobile/statics/settings/my_flutter_app_icons.dart';
import '../../../providers/provider.dart';

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
  final stepsController = TextEditingController();
  final distanceController = TextEditingController();
  final QuestionnairProvider excersicePost = QuestionnairProvider();

  @override
  void dispose() {
    distanceController.dispose();
    stepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Crea un widget Form usando el _formKey que creamos anteriormente
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
              ),
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) => newValue.copyWith(
                      text: newValue.text.replaceAll('.', ','),
                    ),
                  ),
                ],
                controller: stepsController,
                decoration: InputDecoration(
                    labelText: 'steps'.tr.capitalizeFirst!,
                    prefixIcon: Icon(
                      MyFlutterApp.shoe_prints,
                      size: 18,
                    ),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter text'.tr.capitalizeFirst!;
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) => newValue.copyWith(
                      text: newValue.text.replaceAll(',', '.'),
                    ),
                  ),
                ],
                controller: distanceController,
                decoration: InputDecoration(
                    labelText: 'distance'.tr.capitalizeFirst!,
                    prefixIcon: Icon(
                      MyFlutterApp.route,
                      size: 18,
                    ),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter text'.tr.capitalizeFirst!;
                  }
                  return null;
                },
              ),
            ),
            /* Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'Horas de sueño',
                    prefixIcon: Icon(Icons.hotel_rounded),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await excersicePost.PostQuestionnair(
                          int.parse(stepsController.text),
                          double.parse(distanceController.text));
                      stepsController.clear();
                      distanceController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('success data'.tr.capitalizeFirst!)),
                      );
                    }
                  },
                  child: Wrap(
                    children: [
                      Text(
                        'submit'.tr.capitalizeFirst!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.send)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
