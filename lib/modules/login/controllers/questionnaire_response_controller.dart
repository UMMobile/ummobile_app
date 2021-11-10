import 'package:path_provider/path_provider.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile/modules/login/models/login_session.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/models/questionnaire_answer.dart';
import 'package:ummobile/services/storage/questionnaire.dart';
import 'package:ummobile/services/storage/quick_login.dart';
import 'package:get/get.dart';

class QuestionnaireResponseController extends ControllerTemplate {
  QuestionnaireResponseController();

  late QuickLogins storage;

  var responseCount = 0.obs;
  var hasResponses = false.obs;

  List<LoginSession> answeredUsers = List.empty(growable: true);

  @override
  void onInit() {
    fetchQuestionnaireResponse();
    super.onInit();
  }

  @override
  void refreshContent() {
    fetchQuestionnaireResponse();
    super.refreshContent();
  }

  /// Load the data from the Json stored file
  void fetchQuestionnaireResponse() async {
    isLoading(true);
    var directory = await getApplicationDocumentsDirectory();
    storage = QuickLogins(directory);

    List<LoginSession> users = storage.contentCopy;
    Map<String, dynamic> storedQuestionnaire =
        QuestionnaireStorage(directory).contentCopy;

    int usersLength = 0;
    answeredUsers = List.empty(growable: true);

    users.forEach((user) {
      var userAnswer = storedQuestionnaire[user.credential];
      if (userAnswer != null) {
        var answer = QuestionnaireLocalAnswer.fromJson(userAnswer);
        if (answer.isFromToday) {
          usersLength++;
          answeredUsers.add(user);
        }
      }
    });

    responseCount(usersLength);
    hasResponses(responseCount > 0);

    isLoading(false);
  }
}
