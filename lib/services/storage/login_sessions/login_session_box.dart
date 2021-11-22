import 'package:hive/hive.dart';
import 'package:ummobile/services/storage/login_sessions/models/login_session.dart';

/// Stores the user's tokens into a json file
///
/// Creates a json file if not exists in device
class LoginSessionBox {
  /// The box key
  final String _boxId = "login_sessions";

  /// Initializes the box for read/write functions
  Future<Box<LoginSession>> initializeBox() async {
    return await Hive.openBox<LoginSession>(this._boxId);
  }

  /// Closes the box to free memory
  void closeBox() async {
    await Hive.box(this._boxId).close();
  }

  Box<LoginSession> getBox() {
    return Hive.box<LoginSession>(this._boxId);
  }

  /// Returns a list of stored sessions in the device
  List<LoginSession> get contentCopy =>
      Hive.box<LoginSession>(_boxId).values.toList();

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
    this.getBox().add(session);
    return true;
  }

  /// Renew session stored [userId] old credentials
  /// with new credentials [authCredentials]
  refreshSession(String userId, String authCredentials) {
    List<LoginSession> sessions = this.contentCopy;

    LoginSession session =
        sessions.firstWhere((element) => element.userId == userId);
    session.authCredentials = authCredentials;
    session.activeLogin = true;

    int sessionIndex =
        sessions.indexWhere((element) => element.userId == userId);
    var sessionKey = this.getBox().keyAt(sessionIndex);

    this.getBox().put(sessionKey, session);
  }

  /// Makes all stored sessions in device inactive
  void inactiveAllSessions() {
    List<LoginSession> sessions = this.contentCopy;
    sessions = sessions.map((session) {
      session.activeLogin = false;
      return session;
    }).toList();

    sessions.forEach((session) => session.save());
  }

  /// Deletes the [index] session from device storage
  ///
  /// Returns true if the session was successfully deleted
  bool deleteSession(int index) {
    List<LoginSession> sessions = this.contentCopy;
    if (sessions.length > index) {
      this.getBox().deleteAt(index);
      return true;
    }

    return false;
  }
}
