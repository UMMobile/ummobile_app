import 'package:get/instance_manager.dart';
import 'package:ummobile/modules/drawer/modules/portal/documents/controllers/documents_controller.dart';

class DocumentsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocumentsController>(
      () => DocumentsController(),
    );
  }
}
