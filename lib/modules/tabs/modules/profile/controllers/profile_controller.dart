import 'package:get/get.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class ProfileController extends ControllerTemplate with StateMixin<User> {
  Future<UMMobileUser> get user async {
    String accessToken = await Get.find<LoginController>().token;
    return UMMobileUser(token: accessToken);
  }

  @override
  void onInit() {
    fetchUserInfo();
    super.onInit();
  }

  @override
  void refreshContent() {
    change(null, status: RxStatus.loading());
    fetchUserInfo();
    super.refreshContent();
  }

  /// * Mehod in charge of loading the necessary data of the page
  void fetchUserInfo() async {
    call<User>(
      httpCall: () async =>
          await (await user).getInformation(includePicture: true),
      onSuccess: (data) => change(data, status: RxStatus.success()),
      onCallError: (status) => change(null, status: status),
      onError: (e) => change(null, status: RxStatus.error(e.toString())),
    );
  }
}
