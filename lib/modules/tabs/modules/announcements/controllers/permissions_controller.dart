import 'package:get/get.dart';
import 'package:ummobile/statics/Widgets/form/bottomsheet/bottomsheet_controller.dart';

class PermissionsController extends GetxController {
  final BottomSheetController bottomSheetController = BottomSheetController();

  bool formReady = false;

  void formIsReady(bool value) {
    formReady = value;
    update();
  }

  selectForm(int id) => update();
}
