import 'dart:io';
import 'package:ummobile/modules/login/models/login_session.dart';
import 'package:ummobile/services/storage/json_file.dart';

// TODO (@jonathangomz): [Proposal] Work with maps to use userId instead of index.
// Should not be so hard because I think the JSON file contains a Map.
class QuickLogins extends JsonStorage {
  static final QuickLogins instance = QuickLogins._internal();

  QuickLogins._internal();

  factory QuickLogins(Directory directory) {
    if (!instance.isCreated) {
      instance.create(
          withPath: '${directory.path}/quick_logins.json',
          initialContent: List<LoginSession>.empty(growable: true));
    }
    return instance;
  }

  List<LoginSession> get contentCopy => this.contentAs<List<LoginSession>>(
      (list) => (list as List).map((e) => LoginSession.fromMap(e)).toList());

  LoginSession get currentSessionCopy =>
      this.contentCopy.firstWhere((session) => session.activeLogin,
          orElse: () => LoginSession.empty());

  bool get allAreInactive =>
      this.contentCopy.every((session) => !session.activeLogin);

  bool add(LoginSession session) {
    List<LoginSession> sessions = this.contentCopy;
    if (sessions.length >= 3) {
      return false;
    }
    sessions.add(session);
    return this.writeContent(LoginSession.usersToMap(sessions));
  }

  @deprecated
  renewSession(int index, String authCredentials) {
    inactiveAllSessions();

    List<LoginSession> sessions = this.contentCopy;
    sessions[index].authCredentials = authCredentials;
    sessions[index].activeLogin = true;

    this.writeContent(LoginSession.usersToMap(sessions));
  }

  refreshSession(String userId, String authCredentials) {
    inactiveAllSessions();

    List<LoginSession> sessions = this.contentCopy;

    LoginSession session =
        sessions.firstWhere((element) => element.credential == userId);
    session.authCredentials = authCredentials;
    session.activeLogin = true;

    sessions.removeWhere((element) => element.credential == userId);
    sessions.add(session);

    this.writeContent(LoginSession.usersToMap(sessions));
  }

  inactiveAllSessions() {
    List<LoginSession> sessions = this.contentCopy;
    sessions = sessions.map((session) {
      session.activeLogin = false;
      return session;
    }).toList();

    this.writeContent(LoginSession.usersToMap(sessions));
  }

  deleteSession(int index) {
    List<LoginSession> sessions = this.contentCopy;
    if (sessions.length > index) {
      sessions.removeAt(index);
    }
    this.writeContent(LoginSession.usersToMap(sessions));
  }
}
