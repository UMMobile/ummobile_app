import 'package:get/get.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class ScoresController extends ControllerTemplate
    with StateMixin<AllSemesters> {
  Future<UMMobileAcademic> get academicApi async {
    String accessToken = await Get.find<LoginController>().token;
    return UMMobileAcademic(token: accessToken);
  }

  @override
  void onInit() {
    fetchScores();
    super.onInit();
  }

  @override
  void refreshContent() {
    change(null, status: RxStatus.loading());
    fetchScores();
    super.refreshContent();
  }

  /// * Mehod in charge of loading the necessary data of the page
  void fetchScores() async {
    call<AllSemesters>(
      httpCall: () async => await (await academicApi).getAllSemesters(),
      onSuccess: (data) => change(data, status: RxStatus.success()),
      onCallError: (status) => change(null, status: status),
      onError: (e) => change(null, status: RxStatus.error(e.toString())),
    );
  }
}
