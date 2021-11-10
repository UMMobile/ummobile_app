import 'package:get/instance_manager.dart';
import 'package:ummobile/modules/drawer/modules/portal/current/controllers/current_subjects_controller.dart';

class CurrentSubjectsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CurrentSubjectsController>(
      () => CurrentSubjectsController(),
    );
  }
}
