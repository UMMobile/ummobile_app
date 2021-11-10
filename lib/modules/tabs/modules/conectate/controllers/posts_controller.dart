import 'package:get/get.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/modules/tabs/modules/conectate/controllers/stories_controller.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class PostsController extends ControllerTemplate with StateMixin {
  Future<UMMobileCommunication> get apiConectate async {
    String accessToken = await Get.find<LoginController>().token;
    return UMMobileCommunication(token: accessToken);
  }

  var eventsObservable = List<Post>.empty(growable: true).obs;
  var newsObservable = List<Post>.empty(growable: true).obs;
  var blogObservable = List<Post>.empty(growable: true).obs;

  @override
  void onInit() {
    fetchPosts();
    super.onInit();
  }

  @override
  void refreshContent() {
    change(null, status: RxStatus.loading());
    fetchPosts();
    super.refreshContent();
  }

  /// * Mehod in charge of loading the necessary data of the page
  Future<void> fetchPosts() async {
    await call<List<Post>>(
      httpCall: () async => await (await apiConectate).getBlog(quantity: 14),
      onSuccess: (data) => blogObservable(data),
      onCallError: (status) {
        change(null, status: status);
        return;
      },
      onError: (e) {
        change(null, status: RxStatus.error(e.toString()));
        return;
      },
    );

    await call<List<Post>>(
      httpCall: () async => await (await apiConectate).getEvents(quantity: 14),
      onSuccess: (data) => eventsObservable(data),
      onCallError: (status) {
        change(null, status: status);
        return;
      },
      onError: (e) {
        change(null, status: RxStatus.error(e.toString()));
        return;
      },
    );

    await call<List<Post>>(
      httpCall: () async => await (await apiConectate).getNews(quantity: 14),
      onSuccess: (data) => newsObservable(data),
      onCallError: (status) {
        change(null, status: status);
        return;
      },
      onError: (e) {
        change(null, status: RxStatus.error(e.toString()));
        return;
      },
    );

    change(null, status: RxStatus.success());
  }

  /// * Mehod in charge of refresh the necessary data when using the pull to refresh option
  Future<void> refreshPosts() async {
    change(null, status: RxStatus.loading());

    Get.find<StoriesController>().refreshContent();
    await fetchPosts();
  }
}
