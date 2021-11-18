import 'dart:io';
import 'package:ummobile/modules/login/models/login_session.dart';
import 'package:ummobile/services/storage/json_file.dart';

// TODO (@jonathangomz): [Proposal] Work with maps to use userId instead of index.
// Should not be so hard because I think the JSON file contains a Map.

/// Stores the user's tokens into a json file
///
/// Creates a json file if not exists in device
class QuickLogins extends JsonStorage {
  /// The variable in charge of retrieving existing file in user's device
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

  /// Returns a list of stored sessions in the device
  List<LoginSession> get contentCopy => this.contentAs<List<LoginSession>>(
      (list) => (list as List).map((e) => LoginSession.fromMap(e)).toList());

  /// Returns the current active session
  ///
  /// The active session is the one that the user didn't logout at the end of
  /// the app usage.
  /// Returns LoginSession.empty if all sessions are inactive
  LoginSession get activeSessionCopy =>
      this.contentCopy.firstWhere((session) => session.activeLogin,
          orElse: () => LoginSession.empty());

  /// True if all sessions stored are inactive
  bool get areAllInactive =>
      this.contentCopy.every((session) => !session.activeLogin);

  /// Stores a new session [session] into the device storage
  ///
  /// True if the operation completes succesfully
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

  /// Renew session stored [userId] old credentials
  /// with new credentials [authCredentials]
  refreshSession(String userId, String authCredentials) {
    List<LoginSession> sessions = this.contentCopy;

    LoginSession session =
        sessions.firstWhere((element) => element.userId == userId);
    session.authCredentials = authCredentials;
    session.activeLogin = true;

    sessions.removeWhere((element) => element.userId == userId);
    sessions.add(session);

    this.writeContent(LoginSession.usersToMap(sessions));
  }

  /// Makes all stored sessions in device inactive
  inactiveAllSessions() {
    List<LoginSession> sessions = this.contentCopy;
    sessions = sessions.map((session) {
      session.activeLogin = false;
      return session;
    }).toList();

    this.writeContent(LoginSession.usersToMap(sessions));
  }

  /// Deletes the [index] session from device storage
  deleteSession(int index) {
    List<LoginSession> sessions = this.contentCopy;
    if (sessions.length > index) {
      sessions.removeAt(index);
    }
    this.writeContent(LoginSession.usersToMap(sessions));
  }
}
