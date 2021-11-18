import 'package:get/get.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class CurrentSubjectsController extends ControllerTemplate
    with StateMixin<List<Subject>> {
  Future<UMMobileAcademic> get academicApi async {
    String accessToken = await Get.find<LoginController>().token;
    return UMMobileAcademic(token: accessToken);
  }

  @override
  void onInit() {
    fetchCurrentSubjects();
    super.onInit();
  }

  @override
  void refreshContent() {
    change(null, status: RxStatus.loading());
    fetchCurrentSubjects();
    super.refreshContent();
  }

  ///  Loads the current subjects of the user
  void fetchCurrentSubjects() async {
    call<Semester>(
      httpCall: () async => await (await academicApi).getCurrentSemester(),
      onSuccess: (data) => change(data.subjects, status: RxStatus.success()),
      onCallError: (status) => change(null, status: status),
      onError: (e) => change(null, status: RxStatus.error(e.toString())),
    );
  }
}
