import 'package:get/get.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class DocumentImagesController extends ControllerTemplate
    with StateMixin<List<DocumentPage>> {
  /// The document id
  final int documentId;

  /// The amount of pages in the document
  final int pagesCount;

  /// The document pages
  List<DocumentPage> pages = List<DocumentPage>.empty(growable: true);

  DocumentImagesController(this.documentId, this.pagesCount);

  Future<UMMobileAcademic> get academicApi async {
    String accessToken = await Get.find<LoginController>().token;
    return UMMobileAcademic(token: accessToken);
  }

  @override
  void onInit() {
    fetchPages();
    super.onInit();
  }

  @override
  void refreshContent() {
    change(null, status: RxStatus.loading());
    fetchPages();
    super.refreshContent();
  }

  void fetchPages() async {
    for (int i = 0; i < pagesCount; i++) {
      await call<DocumentPage>(
        httpCall: () async =>
            await (await academicApi).getImagePage(this.documentId, i + 1),
        onSuccess: (data) => pages.add(data),
        onCallError: (status) => change(null, status: status),
        onError: (e) => change(null, status: RxStatus.error(e.toString())),
      );
    }

    if (pages.isNotEmpty) {
      change(pages, status: RxStatus.success());
    } else {
      change(pages, status: RxStatus.empty());
    }
  }
}
