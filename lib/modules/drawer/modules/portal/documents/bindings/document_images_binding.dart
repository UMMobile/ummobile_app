import 'package:get/get.dart';
import 'package:ummobile/modules/drawer/modules/portal/documents/controllers/document_images_controller.dart';

class DocumentImagesBinding implements Bindings {
  final int documentId;

  final int pagesCount;

  DocumentImagesBinding(this.documentId, this.pagesCount);

  @override
  void dependencies() {
    Get.lazyPut<DocumentImagesController>(
        () => DocumentImagesController(documentId, pagesCount));
  }
}
