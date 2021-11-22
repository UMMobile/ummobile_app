import 'package:hive_flutter/hive_flutter.dart';

import 'login_sessions/models/login_session.dart';

class RegisterHiveAdapters {
  RegisterHiveAdapters() {
    Hive.registerAdapter(LoginSessionAdapter());
  }
}
