import 'package:hive_flutter/hive_flutter.dart';

import 'login_sessions/models/login_session.dart';
import 'questionnaire_responses/models/questionnaire_response.dart';

class RegisterHiveAdapters {
  RegisterHiveAdapters() {
    Hive.registerAdapter(LoginSessionAdapter());
    Hive.registerAdapter(QuestionnaireResponseAdapter());
  }
}
