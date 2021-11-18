import 'package:flutter/cupertino.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/state_manager.dart';
import 'package:new_version/new_version.dart';
import 'package:oauth2/oauth2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ummobile/modules/login/models/login_session.dart';
import 'package:ummobile/modules/login/utils/validate_login.dart';
import 'package:ummobile/services/authentication/auth.dart';
import 'package:ummobile/services/onesignal/operations.dart';
import 'package:ummobile/services/storage/quick_login.dart';
import 'package:ummobile/statics/templates/controller_template.dart';

class LoginController extends ControllerTemplate {
  /// The amount of user that can be saved.
  static const double max_users = 2;

  /// The context to use for new update dialog.
  final BuildContext context;

  /// True if Quick Logins view should be displayed.
  var showQuickLogins = false.obs;

  /// The saved users.
  var users = List<LoginSession>.empty(growable: true).obs;

  /// The active user id.
  String activeUserId = '';

  /// The credentials for active user.
  Credentials credentials = Credentials('');

  /// The storage service for saved users.
  late QuickLogins storage;

  /// The access token of this [credentials].
  ///
  /// If access token is expired will try to refresh the credentials. Returns the expired access token if cannot refresh the credentials.
  Future<String> get token async {
    if (this.credentials.isExpired) {
      Credentials newCredentials = await refresh(this.credentials);
      if (newCredentials.accessToken.isNotEmpty) {
        // Update credentials on state (this.credentials)
        this.setUserInfo(this.activeUserId, newCredentials);
        // Save new credentials
        this.storage.refreshSession(this.activeUserId, newCredentials.toJson());
        return newCredentials.accessToken;
      }
    }
    return this.credentials.accessToken;
  }

  /// True if the storage is not full according by [max_users].
  bool get isNotFull => this.storage.contentCopy.length < max_users;

  LoginController(this.context);

  @override
  void onInit() {
    loadLoginConfiguration();
    super.onInit();
  }

  void loadLoginConfiguration() async {
    VersionStatus? appStatus = await fetchAppVersion();

    this.loadStoredUsers();
    bool lastSessionIsActive = this.tryLoadLastSession();

    if (appStatus != null && !appStatus.canUpdate && lastSessionIsActive) {
      loginTransition();
    }
  }

  void setUserInfo(String userId, Credentials credentials) {
    if (this.activeUserId != userId) {
      this.activeUserId = userId;
      setPushNotificationUserId(userId);
    }
    this.credentials = credentials;
  }

  Future<VersionStatus?> fetchAppVersion() async {
    final newVersion = NewVersion();
    VersionStatus? appStatus = await newVersion.getVersionStatus();
    if (appStatus != null) {
      // debugPrint(_appStatus!.releaseNotes);
      // debugPrint(_appStatus!.appStoreLink);
      // debugPrint(_appStatus!.localVersion);
      // debugPrint(_appStatus!.storeVersion);
      // debugPrint(_appStatus!.canUpdate.toString());
      if (appStatus.canUpdate)
        newVersion.showUpdateDialog(
          context: context,
          versionStatus: appStatus,
          allowDismissal: false,
          dialogTitle: 'update_available_title'.tr,
          dialogText: 'update_available_description'.tr,
        );
    }
    return appStatus;
  }

  /// Loads the data from the Json stored file
  void loadStoredUsers() async {
    this.isLoading(true);

    // Initialize the storage instance for this class
    this.storage = QuickLogins(await getApplicationDocumentsDirectory());

    this.users(this.storage.contentCopy);
    this.showQuickLogins(this.users.isNotEmpty);

    this.isLoading(false);
  }

  /// Saves a new [session] to storage.
  void saveUser(LoginSession session) async {
    this.users.add(session);
    this.storage.add(session);
    this.showQuickLogins(true);
  }

  bool tryLoadLastSession() {
    bool lastSessionIsActive = false;
    if (this.users.isNotEmpty) {
      if (!this.storage.areAllInactive) {
        LoginSession activeSession = this.storage.activeSessionCopy;
        Credentials activeSessionCredentials =
            Credentials.fromJson(activeSession.authCredentials);
        if (!activeSessionCredentials.isExpired) {
          this.setUserInfo(activeSession.userId, activeSessionCredentials);
          lastSessionIsActive = true;
        }
      }
    }
    return lastSessionIsActive;
  }

  /// Removes the user at the specific [index].
  LoginSession removeUser(int index) {
    LoginSession deleted = this.users.removeAt(index);
    showQuickLogins(this.users.isNotEmpty);
    return deleted;
  }

  /// Authenticates the [userId] and [password] and logs into the application.
  void authenticate(String userId, String password) {
    login(userId, password).then((credential) {
      if (credential != null) {
        this.setUserInfo(userId, credential);

        this.storage.inactiveAllSessions();

        if (this.contains(userId)) {
          // Save new credentials & activates the session
          storage.refreshSession(userId, credentials.toJson());
        }

        loginTransition();

        if (!this.contains(userId) && this.isNotFull) {
          // If the user is saved then activates the session
          promptStoreUser(userId, credential);
        }
      }
    });
  }

  /// Returns true if the [userId] is in the users list
  bool contains(String userId) => this
          .storage
          .contentCopy
          .firstWhere((session) => session.userId == userId,
              orElse: () => LoginSession.empty())
          .userId
          .isNotEmpty
      ? true
      : false;
}
