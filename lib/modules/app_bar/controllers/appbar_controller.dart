import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ummobile/modules/app_bar/modules/notifications/controllers/notifications_controller.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/models/questionnaire_answer.dart';
import 'package:ummobile/modules/tabs/modules/profile/models/user_credentials.dart';
import 'package:ummobile/services/storage/questionnaire.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class AppBarController extends GetxController {
  var notificationsCounter = 0.obs;
  var questionnaireCounter = 0.obs;
  var rulesCounter = 0.obs;

  @override
  void onInit() {
    fetchCounters();
    super.onInit();
  }

  void fetchCounters() async {
    questionnaireCounter(await searchUnansweredQuestionnaire());
  }

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

  Future<int> searchUnansweredQuestionnaire() async {
    Map<String, dynamic>? storedQuestionnaire =
        QuestionnaireStorage(await getApplicationDocumentsDirectory())
            .contentCopy[userId];

    bool isFromToday = false;
    if (storedQuestionnaire != null) {
      QuestionnaireLocalAnswer localQuestionnaire =
          QuestionnaireLocalAnswer.fromJson(storedQuestionnaire);
      isFromToday = localQuestionnaire.isFromToday;
    }

    return isFromToday ? 0 : 1;
  }
}
