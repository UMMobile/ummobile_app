import 'package:get/get.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class StoriesController extends ControllerTemplate
    with StateMixin<List<Group>> {
  Future<UMMobileCommunication> get apiConectate async {
    String accessToken = await Get.find<LoginController>().token;
    return UMMobileCommunication(token: accessToken);
  }

  List<Group> get groups {
    // Left only current stories
    state!.forEach((group) => group.stories.removeWhere((story) =>
        story.startDate.isAfter(DateTime.now()) ||
        story.endDate.isBefore(DateTime.now())));
    // Remove groups without stories
    state!.removeWhere((element) => element.stories.isEmpty);
    return state!;
  }

  @override
  void onInit() {
    fetchStories();
    super.onInit();
  }

  @override
  void refreshContent() {
    change(null, status: RxStatus.loading());
    fetchStories();
    super.refreshContent();
  }

  void fetchStories() async {
    await call<List<Group>>(
      httpCall: () async => await (await apiConectate).getStories(),
      onSuccess: (data) {
        if (data.isEmpty)
          change(null, status: RxStatus.empty());
        else
          change(data, status: RxStatus.success());
      },
      onCallError: (status) => change(null, status: status),
      onError: (e) => change(null, status: RxStatus.error(e.toString())),
    );
  }
}
