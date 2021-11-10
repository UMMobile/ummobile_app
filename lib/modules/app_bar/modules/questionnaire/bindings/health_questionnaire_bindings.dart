import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/controllers/questionnaire_controller.dart';

class HealthQuestionnaireBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestionnaireController>(() => QuestionnaireController());
  }
}
