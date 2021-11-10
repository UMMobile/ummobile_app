import 'package:flutter/material.dart';
import 'package:ummobile/statics/Widgets/form/text_field.dart';

import 'form_other.dart';

class InstitutionalPermissionForm extends StatefulWidget {
  InstitutionalPermissionForm({Key? key}) : super(key: key);

  @override
  _InstitutionalPermissionFormState createState() =>
      _InstitutionalPermissionFormState();
}

class _InstitutionalPermissionFormState
    extends State<InstitutionalPermissionForm> {
  final TextEditingController eventController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController accomodationController = TextEditingController();
  final TextEditingController viaticsController = TextEditingController();
  final TextEditingController materialsController = TextEditingController();

  @override
  void initState() {
    this.eventController.addListener(() => setState(() {}));
    this.destinationController.addListener(() => setState(() {}));
    this.accomodationController.addListener(() => setState(() {}));
    this.viaticsController.addListener(() => setState(() {}));
    this.materialsController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    this.eventController.dispose();
    this.destinationController.dispose();
    this.accomodationController.dispose();
    this.viaticsController.dispose();
    this.materialsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        OtherPermissionsForm(),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                  margin: EdgeInsets.only(right: 8),
                  child: UMTextField(
                    label: 'Evento',
                    controller: eventController,
                  )),
            ),
            Flexible(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 8),
                child: UMTextField(
                  label: 'Destino',
                  controller: destinationController,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                  margin: EdgeInsets.only(right: 8),
                  child: UMTextField(
                    label: 'Estancia',
                    controller: accomodationController,
                  )),
            ),
            Flexible(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 8),
                child: UMTextField(
                  label: 'Viaticos',
                  controller: viaticsController,
                ),
              ),
            ),
          ],
        ),
        UMTextField(
          label: 'Materiales',
          controller: materialsController,
        ),
      ],
    );
  }
}
