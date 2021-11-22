import 'package:path_provider/path_provider.dart';
import 'package:ummobile/services/storage/login_sessions/login_session_box.dart';
import 'package:ummobile/services/storage/login_sessions/models/login_session.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/models/questionnaire_answer.dart';
import 'package:ummobile/services/storage/questionnaire.dart';
import 'package:get/get.dart';

class QuestionnaireResponseController extends ControllerTemplate {
  QuestionnaireResponseController();

  final LoginSessionBox storage = LoginSessionBox();

  /// The number of stored users that has answered the questionnaire
  var responseCount = 0.obs;

  /// True if at least one user has answered the questionnaire
  var hasResponses = false.obs;

  /// The list of users that answered the questionnaire
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

  /// Loads the data from the Json stored file
  void fetchQuestionnaireResponse() async {
    isLoading(true);
    var directory = await getApplicationDocumentsDirectory();
    await storage.initializeBox();

    List<LoginSession> users = storage.contentCopy;
    Map<String, dynamic> storedQuestionnaire =
        QuestionnaireStorage(directory).contentCopy;

    int usersLength = 0;
    answeredUsers = List.empty(growable: true);

    users.forEach((user) {
      var userAnswer = storedQuestionnaire[user.userId];
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
