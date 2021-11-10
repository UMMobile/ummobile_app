import 'package:get/instance_manager.dart';
import 'package:ummobile/modules/app_bar/modules/notifications/controllers/notifications_controller.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/controllers/questionnaire_controller.dart';
import 'package:ummobile/modules/drawer/modules/portal/current/controllers/current_subjects_controller.dart';
import 'package:ummobile/modules/drawer/modules/portal/documents/controllers/documents_controller.dart';
import 'package:ummobile/modules/drawer/modules/portal/ledger/controllers/balances_controller.dart';
import 'package:ummobile/modules/drawer/modules/portal/ledger/controllers/movements_controller.dart';
import 'package:ummobile/modules/drawer/modules/portal/scores/controllers/scores_controller.dart';
import 'package:ummobile/modules/tabs/modules/calendar/controllers/calendar_controller.dart';
import 'package:ummobile/modules/tabs/modules/conectate/controllers/posts_controller.dart';
import 'package:ummobile/modules/tabs/modules/conectate/controllers/stories_controller.dart';
import 'package:ummobile/modules/tabs/modules/payments/controllers/payments_controller.dart';
import 'package:ummobile/modules/tabs/modules/profile/controllers/profile_controller.dart';

import '../../app_bar/controllers/appbar_controller.dart';
import '../../drawer/controllers/drawer.dart';

class TabsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(NotificationsController());
    Get.put(AppBarController());
    Get.put(UmDrawerController());

    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<PaymentsController>(
      () => PaymentsController(),
    );
    Get.lazyPut<PostsController>(
      () => PostsController(),
      fenix: true,
    );
    Get.lazyPut<StoriesController>(
      () => StoriesController(),
      fenix: true,
    );
    Get.lazyPut<UmCalendarController>(
      () => UmCalendarController(),
    );
  }

  void reset() {
    Get.delete<NotificationsController>();
    Get.delete<AppBarController>();
    Get.delete<UmDrawerController>();

    Get.delete<ProfileController>();
    Get.delete<PaymentsController>();
    Get.delete<PostsController>();
    Get.delete<StoriesController>();
    Get.delete<UmCalendarController>();
    Get.delete<CurrentSubjectsController>();
    Get.delete<ScoresController>();
    Get.delete<BalancesController>();
    Get.delete<MovementsController>();
    Get.delete<DocumentsController>();
    Get.delete<QuestionnaireController>();
  }
}
