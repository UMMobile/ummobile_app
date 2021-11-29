import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/notifications/controllers/notifications_controller.dart';
import 'package:ummobile/modules/tabs/modules/profile/models/user_credentials.dart';
import 'package:ummobile/services/storage/questionnaire_responses/models/questionnaire_response.dart';
import 'package:ummobile/services/storage/questionnaire_responses/questionnaire_responses_box.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class AppBarController extends GetxController {
  /// The number of unanswered questionnaires
  var questionnaireCounter = 0.obs;

  /// The number of newly added rules
  var rulesCounter = 0.obs;

  @override
  void onInit() {
    fetchCounters();
    super.onInit();
  }

  void fetchCounters() async {
    questionnaireCounter(await searchUnansweredQuestionnaire());
  }

  /// Returns the amount of unreaded notifications
  int searchNewNotifications() {
    List<Notification> notifications =
        Get.find<NotificationsController>().items;
    int counter = 0;
    notifications.forEach((notification) {
      if (notification.isSeen) return;
      counter++;
    });

    return counter;
  }

  /// Returns 1 if the covid Questionnaire is unanswered for the current day
  Future<int> searchUnansweredQuestionnaire() async {
    final QuestionnaireResponsesBox storage = QuestionnaireResponsesBox();
    storage.initializeBox();

    QuestionnaireResponse? storedQuestionnaire =
        storage.findResponseByCredential(userId);

    bool isFromToday = false;
    if (storedQuestionnaire != null) {
      isFromToday = storedQuestionnaire.isFromToday;
    }

    return isFromToday ? 0 : 1;
  }
}
