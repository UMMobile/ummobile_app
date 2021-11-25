import 'package:ummobile/services/storage/login_sessions/login_session_box.dart';
import 'package:ummobile/services/storage/login_sessions/models/login_session.dart';
import 'package:ummobile/services/storage/questionnaire_responses/questionnaire_responses_box.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:get/get.dart';

class QuestionnaireResponseController extends ControllerTemplate {
  QuestionnaireResponseController();

  final LoginSessionBox _sessionsStorage = LoginSessionBox();

  final QuestionnaireResponsesBox _responsesStorage =
      QuestionnaireResponsesBox();

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

    await _sessionsStorage.initializeBox();
    await _responsesStorage.initializeBox();

    List<LoginSession> users = _sessionsStorage.contentCopy;

    int usersLength = 0;
    answeredUsers = List.empty(growable: true);

    users.forEach((user) {
      var userAnswer = _responsesStorage.findResponseByCredential(user.userId);
      if (userAnswer != null && userAnswer.isFromToday) {
        usersLength++;
        answeredUsers.add(user);
      }
    });

    responseCount(usersLength);
    hasResponses(responseCount > 0);

    isLoading(false);
  }
}
