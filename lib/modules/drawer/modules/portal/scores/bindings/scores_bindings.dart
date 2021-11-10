import 'package:get/instance_manager.dart';
import 'package:ummobile/modules/drawer/modules/portal/scores/controllers/scores_controller.dart';

class ScoresBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScoresController>(
      () => ScoresController(),
    );
  }
}
